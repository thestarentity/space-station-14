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
