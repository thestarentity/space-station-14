using Robust.Shared.GameStates;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Marca um borg cujo painel de manutenção foi TRANCADO pela IA de estação. Enquanto presente,
/// ninguém consegue abrir/fechar o painel de fios (o <see cref="Content.Shared.Wires.AttemptChangePanelEvent"/>
/// é cancelado). Uso defensivo (proteger um borg amigo de ser emagado) ou ofensivo (blindar um borg
/// subvertido contra reset). Networked para o cliente prever o bloqueio e rotular o botão do radial.
/// </summary>
[RegisterComponent, NetworkedComponent]
public sealed partial class StationAiBorgPanelLockComponent : Component;
