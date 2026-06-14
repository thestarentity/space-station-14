using Content.Shared.Atmos.Monitor.Components;
using Robust.Shared.GameStates;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Marca um alarme de ar como controlável pela IA de estação pelo menu radial (alt-clique).
/// Existe pra o CLIENTE ter onde pendurar o handler do radial — o <c>AirAlarmComponent</c> é
/// server-only (mesmo truque da APC). <see cref="CurrentMode"/> é espelhado pelo servidor pra o
/// radial mostrar qual modo está ativo (feedback limpo).
/// </summary>
[RegisterComponent, NetworkedComponent, AutoGenerateComponentState]
public sealed partial class StationAiAirAlarmControllableComponent : Component
{
    /// <summary>
    /// Modo atual do alarme, espelhado do servidor pro cliente rotular o botão ativo.
    /// </summary>
    [DataField, AutoNetworkedField]
    public AirAlarmMode CurrentMode = AirAlarmMode.Filtering;
}
