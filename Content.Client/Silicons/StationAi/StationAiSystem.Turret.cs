using Content.Shared.Lock;
using Content.Shared.Silicons.StationAi;
using Content.Shared.TurretController;
using Robust.Shared.Utility;

namespace Content.Client.Silicons.StationAi;

public sealed partial class StationAiSystem
{
    private readonly ResPath _turretRsi = new ResPath("/Textures/Structures/Wallmounts/turret_controls.rsi");

    private void InitializeTurret()
    {
        SubscribeLocalEvent<DeployableTurretControllerComponent, GetStationAiRadialEvent>(OnTurretGetRadial);
    }

    private void OnTurretGetRadial(Entity<DeployableTurretControllerComponent> ent, ref GetStationAiRadialEvent args)
    {
        var state = ent.Comp.ArmamentState;

        // Armamento das torretas (o ativo mostra "(ativo)"). -1 desligar, 0 atordoar, 1 letal.
        AddTurretArmament(args.Actions, state, -1, "safe", "ai-turret-off");
        AddTurretArmament(args.Actions, state, 0, "stun", "ai-turret-stun");

        // Hostil (letal) só sob lei hostil (o servidor reconfirma).
        if (LocalAiIsHostile())
            AddTurretArmament(args.Actions, state, 1, "lethal", "ai-turret-lethal");

        // Trancar/Destrancar o painel de controle (LockComponent) — qualquer lei. A IA fura o ID.
        if (TryComp<LockComponent>(ent.Owner, out var lockComp))
        {
            args.Actions.Add(new StationAiRadial
            {
                Sprite = new SpriteSpecifier.Texture(new ResPath(lockComp.Locked
                    ? "/Textures/Interface/VerbIcons/unlock.svg.192dpi.png"
                    : "/Textures/Interface/VerbIcons/lock.svg.192dpi.png")),
                Tooltip = Loc.GetString(lockComp.Locked ? "ai-turret-unlock" : "ai-turret-lock"),
                Event = new StationAiTurretLockEvent { Lock = !lockComp.Locked },
            });
        }
    }

    private void AddTurretArmament(List<StationAiRadial> actions, int current, int armament, string rsiState, string locKey)
    {
        var label = Loc.GetString(locKey);
        if (current == armament)
            label += " " + Loc.GetString("ai-atmos-active");

        actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_turretRsi, rsiState),
            Tooltip = label,
            Event = new StationAiTurretArmamentEvent { Armament = armament },
        });
    }
}
