using Robust.Shared.GameStates;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Marca um borg IMOBILIZADO pela IA de estação: enquanto presente, a velocidade de movimento do
/// borg é zerada (ele fica enraizado no lugar, mas continua podendo olhar/agir). Diferente de mexer
/// no <c>Active</c> do borg, o borg-jogador NÃO consegue remover este componente. Networked para o
/// cliente prever o efeito e rotular o botão do radial. Toggle reversível, sob qualquer lei.
/// </summary>
[RegisterComponent, NetworkedComponent]
public sealed partial class StationAiBorgImmobilizedComponent : Component;
