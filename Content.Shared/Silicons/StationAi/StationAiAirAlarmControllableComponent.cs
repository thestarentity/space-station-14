using Robust.Shared.GameStates;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Marca um alarme de ar como controlável pela IA de estação pelo menu radial (alt-clique).
/// Existe só pra o CLIENTE ter onde pendurar o handler do radial — o <c>AirAlarmComponent</c> é
/// server-only, então o cliente não enxerga o alarme de outra forma (mesmo truque da APC).
/// Os botões são FIXOS (definir modo X), então não precisa espelhar estado do servidor.
/// </summary>
[RegisterComponent, NetworkedComponent]
public sealed partial class StationAiAirAlarmControllableComponent : Component;
