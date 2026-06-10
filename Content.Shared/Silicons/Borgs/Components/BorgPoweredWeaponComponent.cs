using Robust.Shared.GameStates;

namespace Content.Shared.Silicons.Borgs.Components;

/// <summary>
/// Marks a weapon as powered by the holding borg's power cell instead of its own battery.
/// When the weapon's battery drains, the equivalent charge is pulled from the borg's power cell.
/// </summary>
[RegisterComponent, NetworkedComponent]
public sealed partial class BorgPoweredWeaponComponent : Component
{
    /// <summary>
    /// Multiplier applied to weapon energy drain before pulling from the borg's power cell.
    /// 1.0 = drain exactly as much as the weapon itself used.
    /// </summary>
    [DataField]
    public float BorgDrainMultiplier = 1f;
}
