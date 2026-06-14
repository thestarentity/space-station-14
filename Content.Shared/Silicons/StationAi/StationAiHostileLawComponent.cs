using Robust.Shared.GameStates;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Marcador networked posto na entidade da IA (o "cérebro" com as leis) quando ela
/// está sob um lawset hostil. O cliente usa pra decidir se mostra as opções de
/// "estação inteira" no menu radial das portas — assim o radial fica limpo quando
/// a IA não pode usá-las.
/// </summary>
[RegisterComponent, NetworkedComponent]
public sealed partial class StationAiHostileLawComponent : Component
{
}
