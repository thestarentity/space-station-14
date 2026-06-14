using Robust.Shared.Serialization;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Ação da IA para definir o armamento de TODAS as torretas ligadas a um painel de controle, pelo
/// menu radial (alt-clique no painel). -1 = desligar (inofensivo), 0 = atordoar, 1 = hostil (letal).
/// Letal só sob lawset hostil; o servidor reconfirma. A IA fura a checagem de acesso do painel.
/// </summary>
[Serializable, NetSerializable]
public sealed class StationAiTurretArmamentEvent : BaseStationAiAction
{
    public int Armament;
}

/// <summary>
/// Ação da IA para trancar/destrancar o painel de controle de torretas (o <c>LockComponent</c> do
/// painel) pelo menu radial. A IA fura o ID. <see cref="Lock"/> true = trancar.
/// </summary>
[Serializable, NetSerializable]
public sealed class StationAiTurretLockEvent : BaseStationAiAction
{
    public bool Lock;
}
