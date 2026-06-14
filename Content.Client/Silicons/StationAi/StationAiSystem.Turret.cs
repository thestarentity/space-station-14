using Content.Shared.Lock;
using Content.Shared.Silicons.StationAi;
using Content.Shared.TurretController;
using Robust.Shared.Utility;

namespace Content.Client.Silicons.StationAi;

public sealed partial class StationAiSystem
{
    private void InitializeTurret()
    {
        SubscribeLocalEvent<DeployableTurretControllerComponent, GetStationAiRadialEvent>(OnTurretGetRadial);
    }

    private void OnTurretGetRadial(Entity<DeployableTurretControllerComponent> ent, ref GetStationAiRadialEvent args)
    {
        var state = ent.Comp.ArmamentState;

        // Armamento (o ícone "_on" acende no modo ativo). -1 desligar, 0 atordoar, 1 letal.
        AddTurretArmament(args.Actions, state, -1, "sentry_harmless", "ai-turret-off");
        AddTurretArmament(args.Actions, state, 0, "sentry_stun", "ai-turret-stun");

        // Hostil (letal) só sob lei hostil (o servidor reconfirma).
        if (LocalAiIsHostile())
            AddTurretArmament(args.Actions, state, 1, "sentry_lethal", "ai-turret-lethal");

        // Trancar/Destrancar o painel de controle (LockComponent) — qualquer lei. A IA fura o ID.
        if (TryComp<LockComponent>(ent.Owner, out var lockComp))
        {
            args.Actions.Add(new StationAiRadial
            {
                Sprite = new SpriteSpecifier.Rsi(_aiCustomRsi, lockComp.Locked ? "sentry_panellock_on" : "sentry_panellock_off"),
                Tooltip = Loc.GetString(lockComp.Locked ? "ai-turret-unlock" : "ai-turret-lock"),
                Event = new StationAiTurretLockEvent { Lock = !lockComp.Locked },
            });
        }
    }

    private void AddTurretArmament(List<StationAiRadial> actions, int current, int armament, string stateBase, string locKey)
    {
        actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_aiCustomRsi, current == armament ? $"{stateBase}_on" : $"{stateBase}_off"),
            Tooltip = Loc.GetString(locKey),
            Event = new StationAiTurretArmamentEvent { Armament = armament },
        });
    }
}
