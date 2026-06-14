using Content.Server.Atmos.Monitor.Components;
using Content.Server.Atmos.Monitor.Systems;
using Content.Shared.Administration.Logs;
using Content.Shared.Atmos.Monitor;
using Content.Shared.Atmos.Monitor.Components;
using Content.Shared.Database;
using Content.Shared.DeviceNetwork.Components;
using Content.Shared.Doors.Components;
using Content.Shared.Doors.Systems;
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
    [Dependency] private SharedFirelockSystem _firelock = default!;
    [Dependency] private SharedDoorSystem _door = default!;
    [Dependency] private AtmosAlarmableSystem _atmosAlarmable = default!;
    [Dependency] private ISharedAdminLogManager _adminLogger = default!;

    public override void Initialize()
    {
        base.Initialize();

        SubscribeLocalEvent<AirAlarmComponent, StationAiAirAlarmModeEvent>(OnSetMode);
        SubscribeLocalEvent<FirelockComponent, StationAiFirelockEvent>(OnFirelock);
        SubscribeLocalEvent<StationAiFireAlarmControllableComponent, StationAiFireAlarmEvent>(OnFireAlarm);
    }

    private void OnFireAlarm(EntityUid uid, StationAiFireAlarmControllableComponent comp, StationAiFireAlarmEvent args)
    {
        // Disponível sob qualquer lei. Dispara (Danger → fecha firelocks da área) ou reseta (Normal → reabre).
        if (args.Alert)
            _atmosAlarmable.ForceAlert(uid, AtmosAlarmType.Danger);
        else
            _atmosAlarmable.Reset(uid);

        _adminLogger.Add(LogType.Action, LogImpact.Medium,
            $"{ToPrettyString(args.User):user} {(args.Alert ? "disparou" : "resetou")} o alarme de incêndio {ToPrettyString(uid):target} (firelocks) pela IA de estação.");
        _popup.PopupEntity(Loc.GetString(args.Alert ? "station-ai-firelocks-triggered" : "station-ai-firelocks-reset"), args.User, args.User, PopupType.Medium);
    }

    private void OnFirelock(EntityUid uid, FirelockComponent comp, StationAiFirelockEvent args)
    {
        // Disponível sob qualquer lei. Fechar = fechamento de emergência; abrir = só se não estiver
        // travado por perigo (o próprio firelock recusa/refecha em pressão/temperatura).
        if (args.Close)
            _firelock.EmergencyPressureStop(uid, comp);
        else
            _door.TryOpen(uid, user: args.User);

        _adminLogger.Add(LogType.Action, LogImpact.Medium,
            $"{ToPrettyString(args.User):user} {(args.Close ? "fechou" : "abriu")} o firelock {ToPrettyString(uid):target} pela IA de estação.");
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
