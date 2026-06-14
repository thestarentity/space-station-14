using Robust.Shared.Serialization;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Ação da IA para alternar o disjuntor de uma APC pelo menu radial.
/// Chega ao servidor via <c>StationAiRadialMessage</c> e é levantada na própria APC,
/// onde <c>StationAiApcSystem</c> a executa. É um toggle puro: o servidor lê o estado
/// real do disjuntor e o inverte, então não carrega payload.
/// </summary>
[Serializable, NetSerializable]
public sealed class StationAiApcToggleEvent : BaseStationAiAction
{
}
