using Robust.Shared.GameStates;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Marca um alarme de incêndio como controlável pela IA de estação pelo menu radial (alt-clique).
/// Existe só pra o CLIENTE ter onde pendurar o handler do radial — o controle de alarme atmosférico
/// é server-only (mesmo truque da APC/alarme de ar). Botões FIXOS (disparar/resetar), não toggle.
/// </summary>
[RegisterComponent, NetworkedComponent]
public sealed partial class StationAiFireAlarmControllableComponent : Component;
