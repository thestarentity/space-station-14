using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Content.Server.Administration.Notes;
using Content.Server.Database;
using Content.Shared.Players.PlayTimeTracking;
using Robust.Server.ServerStatus;
using Robust.Shared.Network;

namespace Content.Server.Administration;

/// <summary>
/// Endpoints de perfil do jogador — playtime e notas/bans para o /perfil Discord.
///
/// Todos requerem:  Authorization: SS14Token &lt;admin.api_token&gt;
///
/// Endpoints:
///   GET /admin/profile?userId=&lt;guid&gt;  — playtime + contagem de notas e bans
/// </summary>
public sealed partial class ServerApi
{
    [Dependency] private IAdminNotesManager _notes = default!;
    [Dependency] private ISharedPlaytimeManager _playtime = default!;

    private void _RegisterProfileEndpoints()
    {
        RegisterHandler(HttpMethod.Get, "/admin/profile", GetPlayerProfile);
    }

    // ── GET /admin/profile?userId=<guid> ──────────────────────────────────────
    //
    // Retorna um resumo do jogador para o comando /perfil do Discord.
    //
    // Resposta:
    //   {
    //     "UserId":        "xxxxxxxx-...",
    //     "Username":      "Starentity",
    //     "PlaytimeHours": 42.5,
    //     "Warns":         2,
    //     "Bans":          0,
    //     "ActiveBan":     false
    //   }

    private async Task GetPlayerProfile(IStatusHandlerContext context)
    {
        if (!await CheckAccess(context))
            return;

        var query  = ParseQuery(context.Url.Query);
        var rawId  = query.GetValueOrDefault("userId");
        if (string.IsNullOrWhiteSpace(rawId) || !Guid.TryParse(rawId, out var guid))
        {
            await RespondBadRequest(context, "Query param 'userId' deve ser um GUID válido.");
            return;
        }

        var userId = new NetUserId(guid);

        // Busca notas e bans no banco de dados do servidor
        var remarks = await _notes.GetAllAdminRemarks(guid);
        var bans    = await _db.GetBansAsync(
            address: null,
            userId: userId,
            hwId: null,
            modernHWIds: null,
            includeUnbanned: true);
        var activeBan = await _db.GetBansAsync(
            address: null,
            userId: userId,
            hwId: null,
            modernHWIds: null,
            includeUnbanned: false);

        // Contagem de warns = notas que NÃO são bans (BanNoteRecord cobre server ban + role ban)
        var warns = remarks.Count(r => r is not BanNoteRecord);

        // Playtime — precisa rodar na main thread pois acessa o cache em memória
        double playtimeHours = 0;
        if (_playerManager.TryGetSessionById(userId, out var session))
        {
            var times = _playtime.GetPlayTimes(session);
            if (times.TryGetValue(PlayTimeTrackingShared.TrackerOverall, out var span))
                playtimeHours = span.TotalHours;
        }
        else
        {
            // Jogador offline — busca no banco de dados
            var dbTimes = await _db.GetPlayTimes(userId);
            var overall = dbTimes.FirstOrDefault(t => t.Tracker == PlayTimeTrackingShared.TrackerOverall);
            if (overall != null)
                playtimeHours = overall.TimeSpent.TotalHours;
        }

        // Tenta resolver o nome pelo GUID (passa o GUID como string para a busca)
        var located = await _locator.LookupIdByNameOrIdAsync(rawId);
        var username = located?.Username ?? rawId;

        await context.RespondJsonAsync(new PlayerProfileResponse
        {
            UserId        = guid,
            Username      = username,
            PlaytimeHours = Math.Round(playtimeHours, 1),
            Warns         = warns,
            Bans          = bans.Count,
            ActiveBan     = activeBan.Count > 0,
        });
    }

    // ── DTOs ───────────────────────────────────────────────────────────────────

    private sealed class PlayerProfileResponse
    {
        public required Guid   UserId        { get; init; }
        public required string Username      { get; init; }
        public required double PlaytimeHours { get; init; }
        public required int    Warns         { get; init; }
        public required int    Bans          { get; init; }
        public required bool   ActiveBan     { get; init; }
    }
}
