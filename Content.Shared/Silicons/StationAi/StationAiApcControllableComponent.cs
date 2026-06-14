using Robust.Shared.GameStates;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Marca uma APC como controlável pela IA de estação pelo menu radial (alt-clique).
/// O servidor espelha aqui o estado do disjuntor para o cliente poder rotular o botão
/// (cortar vs. restaurar), já que <c>ApcComponent</c> só existe no servidor.
/// </summary>
[RegisterComponent, NetworkedComponent, AutoGenerateComponentState]
public sealed partial class StationAiApcControllableComponent : Component
{
    /// <summary>
    /// Disjuntor principal da APC ligado? Mantido em sincronia pelo servidor.
    /// </summary>
    [DataField, AutoNetworkedField]
    public bool PowerOn = true;
}
