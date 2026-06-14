using Content.Shared.Examine;
using Content.Shared.Popups;
using Content.Shared.Wires;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Faz valer o trancamento do painel de um borg pela IA (<see cref="StationAiBorgPanelLockComponent"/>):
/// enquanto o marcador estiver presente, ninguém abre nem fecha o painel de fios. Roda no shared para a
/// predição do cliente já bloquear (sem flicker). A ação de trancar/destrancar em si fica no servidor
/// (StationAiBorgSystem), disparada pelo menu radial.
/// </summary>
public sealed partial class SharedStationAiBorgPanelLockSystem : EntitySystem
{
    [Dependency] private SharedPopupSystem _popup = default!;

    public override void Initialize()
    {
        base.Initialize();

        SubscribeLocalEvent<StationAiBorgPanelLockComponent, AttemptChangePanelEvent>(OnAttemptChangePanel);
        SubscribeLocalEvent<StationAiBorgPanelLockComponent, ExaminedEvent>(OnExamine);
    }

    private void OnExamine(EntityUid uid, StationAiBorgPanelLockComponent comp, ExaminedEvent args)
    {
        // Indicador visível de que o painel está travado (senão um painel trancado fechado
        // parece igual a um destrancado fechado).
        args.PushMarkup(Loc.GetString("station-ai-borg-panel-locked-examine"));
    }

    private void OnAttemptChangePanel(Entity<StationAiBorgPanelLockComponent> ent, ref AttemptChangePanelEvent args)
    {
        if (args.Cancelled)
            return;

        args.Cancelled = true;

        if (args.User is { } user)
            _popup.PopupClient(Loc.GetString("station-ai-borg-panel-locked"), ent.Owner, user, PopupType.MediumCaution);
    }
}
