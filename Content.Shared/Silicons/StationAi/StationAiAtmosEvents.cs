using Content.Shared.Atmos.Monitor.Components;
using Robust.Shared.Serialization;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Ação da IA para definir o MODO de um alarme de ar pelo menu radial (alt-clique).
/// <see cref="Mode"/> é o modo-alvo (Filtragem/Encher/Pânico). Pânico (sugar todo o ar) só
/// é permitido sob lawset hostil — o servidor reconfirma.
/// </summary>
[Serializable, NetSerializable]
public sealed class StationAiAirAlarmModeEvent : BaseStationAiAction
{
    public AirAlarmMode Mode;
}
