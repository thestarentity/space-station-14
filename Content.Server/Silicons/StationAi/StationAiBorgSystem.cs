using Content.Shared.Administration.Logs;
using Content.Shared.Database;
using Content.Shared.Emag.Components;
using Content.Shared.Emag.Systems;
using Content.Shared.Popups;
using Content.Shared.Silicons.Borgs.Components;
using Content.Shared.Silicons.StationAi;

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
    [Dependency] private ISharedAdminLogManager _adminLogger = default!;

    public override void Initialize()
    {
        base.Initialize();

        SubscribeLocalEvent<BorgChassisComponent, StationAiSubvertBorgEvent>(OnSubvert);
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
