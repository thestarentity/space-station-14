using Robust.Shared.GameStates;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Marca uma comporta/persiana (blast door / shutter — base <c>BaseShutter</c>) como controlável
/// pela IA de estação pelo menu radial (alt-clique). Existe só pra o CLIENTE ter onde pendurar o
/// handler do radial; o estado (aberto/fechado) é lido do <c>DoorComponent</c>, que já é shared.
/// Toggle, disponível sob qualquer lei (abrir/fechar uma comporta não é letal). A IA fura o
/// controle de acesso da comporta — ver <see cref="Content.Server.Silicons.StationAi.StationAiStructureSystem"/>.
/// </summary>
[RegisterComponent, NetworkedComponent]
public sealed partial class StationAiBlastDoorControllableComponent : Component;
