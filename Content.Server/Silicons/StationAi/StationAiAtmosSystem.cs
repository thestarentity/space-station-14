using Content.Server.Atmos.Monitor.Components;
using Content.Server.Atmos.Monitor.Systems;
using Content.Shared.Administration.Logs;
using Content.Shared.Atmos.Monitor.Components;
using Content.Shared.Database;
using Content.Shared.DeviceNetwork.Components;
using Content.Shared.Popups;
using Content.Shared.Silicons.StationAi;

namespace Content.Server.Silicons.StationAi;

/// <summary>
/// Ações de atmosfera da IA de estação pelo MENU RADIAL (alt-clique num alarme de ar).
/// Define o modo do alarme (Filtragem/Encher/Pânico). Pânico (sugar todo o ar — arma de vácuo)
/// só sob lawset hostil; o gate reusa <see cref="StationAiBulkDoorSystem.IsUserUnderHostileLaw"/>.
/// </summary>
public sealed partial class StationAiAtmosSystem : EntitySystem
{
    [Dependency] private SharedPopupSystem _popup = default!;
    [Dependency] private StationAiBulkDoorSystem _hostile = default!;
    [Dependency] private AirAlarmSystem _airAlarm = default!;
    [Dependency] private ISharedAdminLogManager _adminLogger = default!;

    public override void Initialize()
    {
        base.Initialize();

        SubscribeLocalEvent<AirAlarmComponent, StationAiAirAlarmModeEvent>(OnSetMode);
    }

    private void OnSetMode(EntityUid uid, AirAlarmComponent comp, StationAiAirAlarmModeEvent args)
    {
        // Pânico (esvaziar o ar) só sob lawset hostil. O cliente já esconde, mas o servidor reconfirma.
        if (args.Mode == AirAlarmMode.Panic && !_hostile.IsUserUnderHostileLaw(args.User))
        {
            _popup.PopupEntity(Loc.GetString("station-ai-atmos-denied"), args.User, args.User, PopupType.MediumCaution);
            return;
        }

        // origin = endereço de rede do próprio alarme (igual ao caminho normal da UI).
        var addr = string.Empty;
        if (TryComp<DeviceNetworkComponent>(uid, out var netConn))
            addr = netConn.Address;

        // uiOnly: false → executa de verdade (comanda vents/scrubbers).
        _airAlarm.SetMode(uid, addr, args.Mode, false, comp);

        _adminLogger.Add(LogType.AtmosDeviceSetting, LogImpact.Medium,
            $"{ToPrettyString(args.User):user} definiu o alarme de ar {ToPrettyString(uid):target} para o modo {args.Mode} pela IA de estação.");
        _popup.PopupEntity(Loc.GetString("station-ai-atmos-mode-set"), args.User, args.User, PopupType.Medium);
    }
}
