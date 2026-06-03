using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Content.Server.Antag;
using Content.Server.Antag.Components;
using Content.Server.GameTicking;
using Content.Server.GameTicking.Rules.Components;
using Content.Shared.GameTicking;
using Content.Shared.GameTicking.Components;
using Content.Shared.Mind;
using Robust.Server.ServerStatus;
using Robust.Shared.Network;
using Robust.Shared.Player;

namespace Content.Server.Administration;

/// <summary>
/// Fila de tokens de antag — permite ao bot Discord ativar até 2 jogadores
/// como antags prioritários em uma rodada, sem interferir no sorteio normal.
///
/// Design "push da rodada ativa":
///   O bot detecta via polling que uma nova rodada InRound começou.
///   Após ~30s (próximo ciclo de poll), o bot envia a lista de jogadores
///   com token para cá. O servidor tenta forçar cada um como Traidor.
///   Resultado por jogador é retornado para o bot tratar (refund se falhou).
///
/// Limit: máximo MAX_TOKEN_ANTAGS jogadores por chamada (configurável).
///
/// Requer: Authorization: SS14Token &lt;admin.api_token&gt;
///
/// Endpoints:
///   POST /admin/antags/activate  — ativa lista de antags por token
///   GET  /admin/antags/queue     — mostra quantos antags de token foram ativados nesta rodada
/// </summary>
public sealed partial class ServerApi
{
    private const int MaxTokenAntags = 2;

    // Rastreia quantos token-antags foram ativados na rodada atual (reset no start de rodada).
    // Chave: round_id; valor: count ativados.
    private readonly Dictionary<int, int> _tokenAntagsThisRound = new();

    private void _RegisterAntagQueueEndpoints()
    {
        RegisterHandler(HttpMethod.Post, "/admin/antags/activate", ActivateTokenAntags);
        RegisterHandler(HttpMethod.Get,  "/admin/antags/queue",    GetTokenAntagStatus);
    }

    // ── POST /admin/antags/activate ───────────────────────────────────────────
    //
    // Ativa até MaxTokenAntags jogadores como Traidores.
    // O bot envia os jogadores em ordem de prioridade (FIFO da fila do banco).
    //
    // Body JSON:
    //   { "RoundId": 36, "Players": ["guid1", "guid2"] }
    //
    // Resposta:
    //   {
    //     "RoundId": 36,
    //     "Results": [
    //       { "UserId": "guid1", "Username": "Starentity", "Success": true,  "Error": null },
    //       { "UserId": "guid2", "Username": "Player2",    "Success": false, "Error": "offline" }
    //     ]
    //   }

    private async Task ActivateTokenAntags(IStatusHandlerContext context)
    {
        if (!await CheckAccess(context))
            return;

        var body = await ReadJson<ActivateAntagBody>(context);
        if (body == null)
            return;

        if (body.Players == null || body.Players.Count == 0)
        {
            await RespondBadRequest(context, "Campo 'Players' é obrigatório e não pode estar vazio.");
            return;
        }

        var results = await RunOnMainThread<List<ActivateResult>>(() =>
        {
            var ticker   = _entitySystemManager.GetEntitySystem<GameTicker>();
            var antagSys = _entitySystemManager.GetEntitySystem<AntagSelectionSystem>();

            // Garante que estamos na rodada correta
            if (ticker.RunLevel != GameRunLevel.InRound)
            {
                return body.Players.Select(g => new ActivateResult
                {
                    UserId  = g,
                    Success = false,
                    Error   = "rodada não está InRound",
                }).ToList();
            }

            var roundId       = ticker.RoundId;
            var alreadyUsed   = _tokenAntagsThisRound.GetValueOrDefault(roundId, 0);
            var remaining     = MaxTokenAntags - alreadyUsed;
            var results       = new List<ActivateResult>();
            var activated     = 0;

            foreach (var guidStr in body.Players)
            {
                if (!Guid.TryParse(guidStr, out var guid))
                {
                    results.Add(new ActivateResult { UserId = guidStr, Success = false, Error = "GUID inválido" });
                    continue;
                }

                var userId = new NetUserId(guid);

                // Verifica limite por rodada
                if (activated >= remaining)
                {
                    results.Add(new ActivateResult
                    {
                        UserId  = guidStr,
                        Success = false,
                        Error   = $"limite de {MaxTokenAntags} token-antags por rodada já atingido",
                    });
                    continue;
                }

                // Verifica se o jogador está online
                if (!_playerManager.TryGetSessionById(userId, out var session))
                {
                    results.Add(new ActivateResult { UserId = guidStr, Success = false, Error = "offline" });
                    continue;
                }

                // Verifica se já é antag (evita dupla-força)
                var alreadyAntag = false;
                var ruleEnum = _entityManager.EntityQueryEnumerator<ActiveGameRuleComponent, AntagSelectionComponent>();
                while (ruleEnum.MoveNext(out _, out _, out var antagComp))
                {
                    foreach (var minds in antagComp.AssignedMinds.Values)
                    {
                        foreach (var (mindEnt, _) in minds)
                        {
                            if (_entityManager.TryGetComponent<MindComponent>(mindEnt, out var mc)
                                && mc.UserId == userId)
                            {
                                alreadyAntag = true;
                                break;
                            }
                        }
                        if (alreadyAntag) break;
                    }
                    if (alreadyAntag) break;
                }

                if (alreadyAntag)
                {
                    results.Add(new ActivateResult
                    {
                        UserId   = guidStr,
                        Username = session.Name,
                        Success  = false,
                        Error    = "já é antag nesta rodada",
                    });
                    continue;
                }

                // Força como Traidor (mesmo método que admins usam via UI)
                try
                {
                    antagSys.ForceMakeAntag<TraitorRuleComponent>(session, "Traitor");
                    activated++;
                    _tokenAntagsThisRound[roundId] = alreadyUsed + activated;
                    _sawmill.Info($"[TokenAntag] {session.Name} ativado como Traitor por token (rodada #{roundId})");
                    results.Add(new ActivateResult
                    {
                        UserId   = guidStr,
                        Username = session.Name,
                        Success  = true,
                    });
                }
                catch (Exception ex)
                {
                    _sawmill.Warning($"[TokenAntag] Falha ao forçar {session.Name}: {ex.Message}");
                    results.Add(new ActivateResult
                    {
                        UserId   = guidStr,
                        Username = session.Name,
                        Success  = false,
                        Error    = ex.Message,
                    });
                }
            }

            return results;
        });

        await context.RespondJsonAsync(new ActivateAntagResponse
        {
            RoundId = body.RoundId,
            Results = results,
        });
    }

    // ── GET /admin/antags/queue ────────────────────────────────────────────────
    //
    // Mostra quantos token-antags já foram ativados nesta rodada.
    // Útil para o bot saber se ainda há slots antes de enviar a fila.

    private async Task GetTokenAntagStatus(IStatusHandlerContext context)
    {
        if (!await CheckAccess(context))
            return;

        var status = await RunOnMainThread<TokenAntagStatusResponse>(() =>
        {
            var ticker  = _entitySystemManager.GetEntitySystem<GameTicker>();
            var roundId = ticker.RoundId;
            var used    = _tokenAntagsThisRound.GetValueOrDefault(roundId, 0);
            return new TokenAntagStatusResponse
            {
                RoundId   = roundId,
                RunLevel  = (int) ticker.RunLevel,
                Used      = used,
                Available = MaxTokenAntags - used,
                Max       = MaxTokenAntags,
            };
        });

        await context.RespondJsonAsync(status);
    }

    // ── DTOs ───────────────────────────────────────────────────────────────────

    private sealed class ActivateAntagBody
    {
        public int           RoundId { get; init; }
        public List<string>? Players { get; init; }
    }

    private sealed class ActivateResult
    {
        public string  UserId   { get; init; } = "";
        public string? Username { get; init; }
        public bool    Success  { get; init; }
        public string? Error    { get; init; }
    }

    private sealed class ActivateAntagResponse
    {
        public int                RoundId { get; init; }
        public List<ActivateResult> Results { get; init; } = [];
    }

    private sealed class TokenAntagStatusResponse
    {
        public int RoundId   { get; init; }
        public int RunLevel  { get; init; }
        public int Used      { get; init; }
        public int Available { get; init; }
        public int Max       { get; init; }
    }
}
