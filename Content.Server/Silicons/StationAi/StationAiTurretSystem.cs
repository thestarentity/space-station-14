using Content.Server.TurretController;
using Content.Shared.Administration.Logs;
using Content.Shared.Database;
using Content.Shared.Lock;
using Content.Shared.Popups;
using Content.Shared.Silicons.StationAi;
using Content.Shared.TurretController;

namespace Content.Server.Silicons.StationAi;

/// <summary>
/// Ações da IA de estação sobre PAINÉIS DE CONTROLE DE TORRETA, pelo MENU RADIAL (alt-clique).
/// Define o armamento de todas as torretas ligadas (desligar/atordoar/letal) e tranca/destranca o
/// painel. A IA fura a checagem de acesso. Letal (hostil) só sob lawset hostil — gate reusa
/// <see cref="StationAiBulkDoorSystem.IsUserUnderHostileLaw"/>.
/// </summary>
public sealed partial class StationAiTurretSystem : EntitySystem
{
    [Dependency] private SharedPopupSystem _popup = default!;
    [Dependency] private StationAiBulkDoorSystem _hostile = default!;
    [Dependency] private DeployableTurretControllerSystem _turretController = default!;
    [Dependency] private LockSystem _lock = default!;
    [Dependency] private ISharedAdminLogManager _adminLogger = default!;

    /// <summary>Armamento a partir do qual conta como "hostil" (letal) — só sob lawset hostil.</summary>
    private const int LethalArmament = 1;

    public override void Initialize()
    {
        base.Initialize();

        SubscribeLocalEvent<DeployableTurretControllerComponent, StationAiTurretArmamentEvent>(OnArmament);
        SubscribeLocalEvent<DeployableTurretControllerComponent, StationAiTurretLockEvent>(OnLock);
    }

    private void OnArmament(EntityUid uid, DeployableTurretControllerComponent comp, StationAiTurretArmamentEvent args)
    {
        // Armamento letal (hostil) só sob lawset hostil. O cliente já esconde, o servidor reconfirma.
        if (args.Armament >= LethalArmament && !_hostile.IsUserUnderHostileLaw(args.User))
        {
            _popup.PopupEntity(Loc.GetString("station-ai-turret-denied"), args.User, args.User, PopupType.MediumCaution);
            return;
        }

        _turretController.SetArmamentFromAi((uid, comp), args.Armament, args.User);

        _adminLogger.Add(LogType.ItemConfigure, LogImpact.Medium,
            $"{ToPrettyString(args.User):user} definiu o armamento das torretas de {ToPrettyString(uid):target} para {args.Armament} pela IA de estação.");
        _popup.PopupEntity(Loc.GetString("station-ai-turret-set"), args.User, args.User, PopupType.Medium);
    }

    private void OnLock(EntityUid uid, DeployableTurretControllerComponent comp, StationAiTurretLockEvent args)
    {
        if (!TryComp<LockComponent>(uid, out var lockComp))
            return;

        // A IA fura o ID e a exigência de painel: chama Lock/Unlock crus.
        if (args.Lock)
            _lock.Lock(uid, args.User, lockComp);
        else
            _lock.Unlock(uid, args.User, lockComp);

        _adminLogger.Add(LogType.Action, LogImpact.Medium,
            $"{ToPrettyString(args.User):user} {(args.Lock ? "trancou" : "destrancou")} o painel de torretas {ToPrettyString(uid):target} pela IA de estação.");
    }
}
