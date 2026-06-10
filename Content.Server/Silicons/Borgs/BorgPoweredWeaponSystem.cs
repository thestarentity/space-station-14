using Content.Shared.Power;
using Content.Shared.PowerCell;
using Content.Shared.Silicons.Borgs.Components;
using Robust.Shared.Containers;

namespace Content.Server.Silicons.Borgs;

/// <summary>
/// Drains the holding borg's power cell when a BorgPoweredWeapon fires.
/// </summary>
public sealed partial class BorgPoweredWeaponSystem : EntitySystem
{
    [Dependency] private SharedContainerSystem _container = default!;
    [Dependency] private PowerCellSystem _powerCell = default!;

    public override void Initialize()
    {
        base.Initialize();
        SubscribeLocalEvent<BorgPoweredWeaponComponent, ChargeChangedEvent>(OnChargeChanged);
    }

    private void OnChargeChanged(Entity<BorgPoweredWeaponComponent> weapon, ref ChargeChangedEvent args)
    {
        if (args.Delta >= 0)
            return;

        if (!_container.TryGetContainingContainer((weapon.Owner, null, null), out var container))
            return;

        var holder = container.Owner;

        if (!HasComp<BorgChassisComponent>(holder))
            return;

        var drain = Math.Abs(args.Delta) * weapon.Comp.BorgDrainMultiplier;
        _powerCell.TryUseCharge(holder, drain);
    }
}
