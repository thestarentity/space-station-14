using Robust.Shared.Serialization;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Ação da IA de estação para subverter um borg pelo menu radial (segurar Alt + clicar no borg).
/// Só aparece e só funciona sob um lawset hostil. Reaproveita o pipeline de emag: o borg ganha a
/// lei "obedeça à IA" e o papel de silício subvertido, passando a servir a IA.
/// É um gatilho simples (sem payload): o servidor decide o efeito a partir do estado do borg.
/// </summary>
[Serializable, NetSerializable]
public sealed class StationAiSubvertBorgEvent : BaseStationAiAction
{
}

/// <summary>
/// Ação da IA para desligar um borg pelo menu radial (só sob lei hostil). Reaproveita o mesmo
/// "disable" do console de robótica (ejeta o cérebro do borg após um curto atraso). Um borg
/// subvertido finge desligar, mas continua funcional (proteção já existente do emag).
/// </summary>
[Serializable, NetSerializable]
public sealed class StationAiDisableBorgEvent : BaseStationAiAction
{
}

/// <summary>
/// Ação da IA para detonar (explodir) um borg pelo menu radial (só sob lei hostil + confirmação
/// por duplo-clique). Reaproveita o mesmo "destroy" do console de robótica. Um borg subvertido
/// não explode de fato (proteção já existente do emag).
/// </summary>
[Serializable, NetSerializable]
public sealed class StationAiDetonateBorgEvent : BaseStationAiAction
{
}
