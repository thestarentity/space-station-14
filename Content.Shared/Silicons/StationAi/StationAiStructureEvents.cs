using Robust.Shared.Serialization;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Ação da IA para abrir ou fechar uma comporta/persiana (blast door / shutter) pelo menu radial
/// (alt-clique). Disponível sob qualquer lei. <see cref="Close"/> é decidido no cliente a partir
/// do estado da porta (toggle). A IA fura o controle de acesso da comporta (passa <c>user: null</c>
/// no sistema de portas, que pula a checagem de acesso).
/// </summary>
[Serializable, NetSerializable]
public sealed class StationAiBlastDoorEvent : BaseStationAiAction
{
    public bool Close;
}
