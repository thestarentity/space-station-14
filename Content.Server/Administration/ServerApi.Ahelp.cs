using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Content.Server.Administration.Systems;
using Robust.Server.ServerStatus;
using Robust.Shared.Network;

namespace Content.Server.Administration;

/// <summary>
/// Endpoints do ahelp bidirecional (jogo ↔ Discord).
///
///   GET  /admin/ahelp/pending  — retorna e limpa a fila de ahelps para o bot consumir
///   POST /admin/ahelp/send     — envia resposta do staff Discord para o jogador in-game
/// </summary>
public sealed partial class ServerApi
{
    private void _RegisterAhelpEndpoints()
    {
        RegisterHandler(HttpMethod.Get,  "/admin/ahelp/pending", AhelpGetPending);
        RegisterHandler(HttpMethod.Post, "/admin/ahelp/send",    AhelpSend);
    }

    // ── GET /admin/ahelp/pending ──────────────────────────────────────────────
    //
    // Resposta: JSON array de BotAhelpEntry
    //   [{"UserId":"...","UserName":"...","Text":"...","IsAdmin":false,"RoundId":42,"Timestamp":"..."}]
    // Array vazio se não houver nada pendente.

    private async Task AhelpGetPending(IStatusHandlerContext context)
    {
        var entries = await RunOnMainThread(() =>
        {
            var bwoink = _entitySystemManager.GetEntitySystem<BwoinkSystem>();
            return bwoink.DrainBotRelayQueue();
        });

        await context.RespondJsonAsync(entries);
    }

    // ── POST /admin/ahelp/send ────────────────────────────────────────────────
    //
    // Body: { "UserId": "GUID", "SenderName": "Nome no Discord", "Text": "mensagem" }
    // Retorna 404 se o jogador não estiver online (bwoink não pode ser entregue).

    private async Task AhelpSend(IStatusHandlerContext context)
    {
        var body = await ReadJson<AhelpSendBody>(context);
        if (body == null) return;

        if (!Guid.TryParse(body.UserId, out var userGuid))
        {
            await RespondBadRequest(context, "UserId inválido — use o formato GUID.");
            return;
        }

        var userId = new NetUserId(userGuid);
        bool sent = false;

        await RunOnMainThread(() =>
        {
            var bwoink = _entitySystemManager.GetEntitySystem<BwoinkSystem>();
            sent = bwoink.SendBotResponse(userId, body.SenderName, body.Text);
        });

        if (!sent)
        {
            await RespondError(
                context,
                ErrorCode.PlayerNotFound,
                HttpStatusCode.NotFound,
                "Jogador não está online — bwoink não entregue.");
            return;
        }

        await RespondOk(context);
    }

    private sealed class AhelpSendBody
    {
        public required string UserId     { get; init; }
        public required string SenderName { get; init; }
        public required string Text       { get; init; }
    }
}
