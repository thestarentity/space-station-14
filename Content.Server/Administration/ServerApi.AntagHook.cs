using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Content.Server.Antag.Components;
using Content.Server.GameTicking;
using Content.Server.GameTicking.Presets;
using Content.Shared.GameTicking;
using Content.Shared.GameTicking.Components;
using Content.Shared.Mind;
using Robust.Server.ServerStatus;
using Robust.Shared.Player;

namespace Content.Server.Administration;

/// <summary>
/// Endpoints de antagonistas — expõe a lista de antags da rodada atual para o bot Discord.
///
/// Abordagem "pull" (bot faz polling):
///   GET /admin/antags/active  — retorna todos os antags da rodada em andamento
///   GET /admin/antags/round   — retorna apenas rodada e preset (sem lista, mais leve)
///
/// Por que pull e não push?
///   Push exigiria que o jogo conhecesse a URL do bot (configuração extra).
///   Pull é mais simples, resiliente a restart do bot, e já temos o padrão
///   de polling no cog do ahelp (a cada 5s). Para antags, 30s é suficiente.
///
/// Requer o header:  Authorization: SS14Token &lt;admin.api_token&gt;
/// </summary>
public sealed partial class ServerApi
{
    // ── Registro ───────────────────────────────────────────────────────────────

    private void _RegisterAntagEndpoints()
    {
        RegisterHandler(HttpMethod.Get, "/admin/antags/active", GetActiveAntags);
        RegisterHandler(HttpMethod.Get, "/admin/antags/round",  GetRoundInfo);
    }

    // ── GET /admin/antags/active ───────────────────────────────────────────────
    //
    // Retorna a lista de antags confirmados na rodada atual.
    // Cada entrada inclui UserId, Username, AntagRole e RoundId.
    //
    // Resposta quando em rodada (run_level == 1):
    //   {
    //     "RoundId": 31,
    //     "RunLevel": 1,
    //     "Antags": [
    //       { "UserId": "...", "Username": "Starentity", "AntagRole": "Traitor", "ConfirmedAt": "2026-06-03T..." }
    //     ]
    //   }
    //
    // Quando não há rodada ativa: Antags = [] e RunLevel = 0 ou 2.

    private async Task GetActiveAntags(IStatusHandlerContext context)
    {
        if (!await CheckAccess(context))
            return;

        var response = await RunOnMainThread<ActiveAntagsResponse>(() =>
        {
            var ticker   = _entitySystemManager.GetEntitySystem<GameTicker>();

            var runLevel = (int) ticker.RunLevel;
            var roundId  = ticker.RoundId;
            var antags   = new List<AntagEntry>();

            if (ticker.RunLevel == GameRunLevel.InRound)
            {
                // Itera todas as regras de antag ativas diretamente via EntityManager
                var ruleQuery = _entityManager.EntityQueryEnumerator<ActiveGameRuleComponent, AntagSelectionComponent>();
                while (ruleQuery.MoveNext(out _, out _, out var antagComp))
                {
                    foreach (var (protoId, minds) in antagComp.AssignedMinds)
                    {
                        foreach (var (mindEnt, characterName) in minds)
                        {
                            // MindComponent.UserId é o NetUserId do jogador
                            if (!_entityManager.TryGetComponent<MindComponent>(mindEnt, out var mindComp)
                                || mindComp.UserId == null)
                                continue;

                            var userId   = mindComp.UserId.Value;
                            var username = _playerManager.TryGetSessionById(userId, out var session)
                                ? session.Name
                                : characterName; // fallback: nome do personagem se sessão encerrou

                            antags.Add(new AntagEntry
                            {
                                UserId    = userId.UserId,
                                Username  = username,
                                AntagRole = protoId.Id,
                            });
                        }
                    }
                }
            }

            return new ActiveAntagsResponse
            {
                RoundId  = roundId,
                RunLevel = runLevel,
                Antags   = antags,
            };
        });

        await context.RespondJsonAsync(response);
    }

    // ── GET /admin/antags/round ────────────────────────────────────────────────
    //
    // Versão leve: só retorna RoundId e RunLevel, sem a lista de antags.
    // Útil para o bot detectar mudança de rodada sem processar a lista inteira.

    private async Task GetRoundInfo(IStatusHandlerContext context)
    {
        if (!await CheckAccess(context))
            return;

        var response = await RunOnMainThread<RoundInfoResponse>(() =>
        {
            var ticker = _entitySystemManager.GetEntitySystem<GameTicker>();
            return new RoundInfoResponse
            {
                RoundId  = ticker.RoundId,
                RunLevel = (int) ticker.RunLevel,
                Preset   = ticker.CurrentPreset?.GetType().Name,
            };
        });

        await context.RespondJsonAsync(response);
    }

    // ── DTOs ───────────────────────────────────────────────────────────────────

    private sealed class ActiveAntagsResponse
    {
        public required int              RoundId  { get; init; }
        public required int              RunLevel { get; init; }
        public required List<AntagEntry> Antags   { get; init; }
    }

    private sealed class AntagEntry
    {
        public required Guid   UserId    { get; init; }
        public required string Username  { get; init; }
        public required string AntagRole { get; init; }
    }

    private sealed class RoundInfoResponse
    {
        public required int     RoundId  { get; init; }
        public required int     RunLevel { get; init; }
        public required string? Preset   { get; init; }
    }
}
