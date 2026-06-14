using Content.Shared.Movement.Systems;

namespace Content.Shared.Silicons.StationAi;

/// <summary>
/// Faz valer a imobilização de um borg pela IA (<see cref="StationAiBorgImmobilizedComponent"/>):
/// zera a velocidade de movimento enquanto o marcador estiver presente. Roda no shared para a
/// predição do cliente já travar o movimento (sem solavanco). O toggle em si fica no servidor
/// (StationAiBorgSystem), disparado pelo menu radial.
/// </summary>
public sealed class SharedStationAiBorgImmobilizeSystem : EntitySystem
{
    public override void Initialize()
    {
        base.Initialize();

        SubscribeLocalEvent<StationAiBorgImmobilizedComponent, RefreshMovementSpeedModifiersEvent>(OnRefreshMovement);
    }

    private void OnRefreshMovement(Entity<StationAiBorgImmobilizedComponent> ent, ref RefreshMovementSpeedModifiersEvent args)
    {
        args.ModifySpeed(0f, 0f);
    }
}
