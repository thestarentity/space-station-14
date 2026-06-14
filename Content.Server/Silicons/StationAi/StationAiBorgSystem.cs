using Content.Server.Silicons.Borgs;
using Content.Shared.Administration.Logs;
using Content.Shared.Database;
using Content.Shared.Emag.Components;
using Content.Shared.Emag.Systems;
using Content.Shared.Popups;
using Content.Shared.Silicons.Borgs.Components;
using Content.Shared.Silicons.StationAi;
using Content.Shared.Wires;
using Robust.Shared.Timing;

namespace Content.Server.Silicons.StationAi;

/// <summary>
/// Ações da IA de estação sobre borgs, disparadas pelo MENU RADIAL (segurar Alt + clicar no borg).
/// Por enquanto: <b>Subverter</b> — disponível só sob lawset hostil. Reaproveita todo o pipeline de
/// emag (<see cref="GotEmaggedEvent"/>): o borg ganha a lei "obedeça à IA" + o papel de silício
/// subvertido, e fica imune a tempestade iônica. O gate de "lei hostil" reusa a checagem já mantida
/// por <see cref="StationAiBulkDoorSystem"/>.
/// </summary>
public sealed partial class StationAiBorgSystem : EntitySystem
{
    [Dependency] private SharedPopupSystem _popup = default!;
    [Dependency] private EmagSystem _emag = default!;
    [Dependency] private StationAiBulkDoorSystem _hostile = default!;
    [Dependency] private BorgSystem _borg = default!;
    [Dependency] private SharedWiresSystem _wires = default!;
    [Dependency] private IGameTiming _timing = default!;
    [Dependency] private ISharedAdminLogManager _adminLogger = default!;

    /// <summary>
    /// Janela (em segundos) para confirmar a detonação após o primeiro clique.
    /// </summary>
    private const double DetonateConfirmWindow = 5.0;

    public override void Initialize()
    {
        base.Initialize();

        SubscribeLocalEvent<BorgChassisComponent, StationAiSubvertBorgEvent>(OnSubvert);
        SubscribeLocalEvent<BorgChassisComponent, StationAiDisableBorgEvent>(OnDisable);
        SubscribeLocalEvent<BorgChassisComponent, StationAiDetonateBorgEvent>(OnDetonate);
        SubscribeLocalEvent<BorgChassisComponent, StationAiTogglePanelLockEvent>(OnTogglePanelLock);
    }

    private void OnTogglePanelLock(EntityUid uid, BorgChassisComponent comp, StationAiTogglePanelLockEvent args)
    {
        // Disponível sob QUALQUER lei (uso defensivo de IA leal ou ofensivo de IA malf).
        if (args.Lock)
        {
            // Fecha o painel antes de trancar (senão ficaria aberto e travado). Fecha enquanto o
            // marcador ainda não existe, então o AttemptChangePanelEvent não é cancelado.
            if (TryComp<WiresPanelComponent>(uid, out var panel) && panel.Open)
                _wires.TogglePanel(uid, panel, false, args.User);

            EnsureComp<StationAiBorgPanelLockComponent>(uid);
            _popup.PopupEntity(Loc.GetString("station-ai-borg-panel-lock-on", ("name", Name(uid))), args.User, args.User, PopupType.Medium);
        }
        else
        {
            RemComp<StationAiBorgPanelLockComponent>(uid);
            _popup.PopupEntity(Loc.GetString("station-ai-borg-panel-lock-off", ("name", Name(uid))), args.User, args.User, PopupType.Medium);
        }

        _adminLogger.Add(LogType.Action, LogImpact.Medium,
            $"{ToPrettyString(args.User):user} {(args.Lock ? "trancou" : "destrancou")} o painel do borg {ToPrettyString(uid):target} pela IA de estação.");
    }

    private void OnDisable(EntityUid uid, BorgChassisComponent comp, StationAiDisableBorgEvent args)
    {
        if (!_hostile.IsUserUnderHostileLaw(args.User))
        {
            _popup.PopupEntity(Loc.GetString("station-ai-borg-action-denied"), args.User, args.User, PopupType.MediumCaution);
            return;
        }

        if (!TryComp<BorgTransponderComponent>(uid, out var transponder))
            return;

        // Reaproveita o "disable" do console de robótica (ejeta o cérebro após um atraso).
        _borg.Disable((uid, transponder, comp));

        _adminLogger.Add(LogType.Action, LogImpact.High,
            $"{ToPrettyString(args.User):user} desligou o borg {ToPrettyString(uid):target} pela IA de estação.");
        _popup.PopupEntity(Loc.GetString("station-ai-borg-disable-success", ("name", Name(uid))), args.User, args.User, PopupType.Medium);
    }

    private void OnDetonate(EntityUid uid, BorgChassisComponent comp, StationAiDetonateBorgEvent args)
    {
        if (!_hostile.IsUserUnderHostileLaw(args.User))
        {
            _popup.PopupEntity(Loc.GetString("station-ai-borg-action-denied"), args.User, args.User, PopupType.MediumCaution);
            return;
        }

        var now = _timing.CurTime;

        // Confirmação por duplo-clique: o primeiro clique arma; o segundo (mesmo ator, dentro da
        // janela) detona. Evita detonar por engano numa ação irreversível.
        if (!TryComp<StationAiDetonateArmedComponent>(uid, out var armed) || armed.Armer != args.User || now > armed.Until)
        {
            armed = EnsureComp<StationAiDetonateArmedComponent>(uid);
            armed.Armer = args.User;
            armed.Until = now + TimeSpan.FromSeconds(DetonateConfirmWindow);
            _popup.PopupEntity(Loc.GetString("station-ai-borg-detonate-arm", ("name", Name(uid))), args.User, args.User, PopupType.LargeCaution);
            return;
        }

        RemComp<StationAiDetonateArmedComponent>(uid);

        _adminLogger.Add(LogType.Action, LogImpact.Extreme,
            $"{ToPrettyString(args.User):user} detonou o borg {ToPrettyString(uid):target} pela IA de estação.");
        // Reaproveita o "destroy" do console de robótica (explode o borg).
        _borg.Destroy(uid);
    }

    private void OnSubvert(EntityUid uid, BorgChassisComponent comp, StationAiSubvertBorgEvent args)
    {
        // Só sob lawset hostil. O cliente já esconde o botão, mas o servidor reconfirma (não confiar no cliente).
        if (!_hostile.IsUserUnderHostileLaw(args.User))
        {
            _popup.PopupEntity(Loc.GetString("station-ai-subvert-denied"), args.User, args.User, PopupType.MediumCaution);
            return;
        }

        // Já subvertido/emagado? não empilhar leis "obedeça".
        if (_emag.CheckFlag(uid, EmagType.Interaction))
        {
            _popup.PopupEntity(Loc.GetString("station-ai-subvert-already"), args.User, args.User, PopupType.Medium);
            return;
        }

        // Reaproveita o pipeline de emag: adiciona a lei de obediência, o papel de silício
        // subvertido, o som e o atordoamento. O painel de fios não é exigido para a IA
        // (ver SharedSiliconLawSystem.OnGotEmagged).
        var ev = new GotEmaggedEvent(args.User, EmagType.Interaction);
        RaiseLocalEvent(uid, ref ev);
        if (!ev.Handled)
            return;

        // Marca o borg como emagado: imunidade a tempestade iônica e impede re-subversão.
        var emagged = EnsureComp<EmaggedComponent>(uid);
        emagged.EmagType |= EmagType.Interaction;
        Dirty(uid, emagged);

        _adminLogger.Add(LogType.Action, LogImpact.High,
            $"{ToPrettyString(args.User):user} subverteu o borg {ToPrettyString(uid):target} pela IA de estação.");
        _popup.PopupEntity(Loc.GetString("station-ai-subvert-success", ("name", Name(uid))), args.User, args.User, PopupType.Medium);
    }
}
