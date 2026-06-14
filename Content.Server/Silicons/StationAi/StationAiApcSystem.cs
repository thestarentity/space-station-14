using Content.Server.Power.Components;
using Content.Server.Power.EntitySystems;
using Content.Shared.APC;
using Content.Shared.Silicons.StationAi;
using Content.Shared.UserInterface;

namespace Content.Server.Silicons.StationAi;

/// <summary>
/// Permite à IA de estação cortar/restaurar a energia de uma área pelo disjuntor da APC,
/// usando o menu radial (alt-clique). A IA controla APCs livremente, sem checagem de acesso
/// (como no SS13) — o whitelist do menu radial já garante que só uma IA válida chega aqui.
/// Mantém <see cref="StationAiApcControllableComponent.PowerOn"/> em sincronia para o cliente
/// rotular o botão corretamente.
/// </summary>
public sealed partial class StationAiApcSystem : EntitySystem
{
    [Dependency] private ApcSystem _apc = default!;

    public override void Initialize()
    {
        base.Initialize();

        SubscribeLocalEvent<StationAiApcControllableComponent, MapInitEvent>(OnMapInit);
        SubscribeLocalEvent<StationAiApcControllableComponent, StationAiApcToggleEvent>(OnToggle);
        SubscribeLocalEvent<StationAiApcControllableComponent, ApcMainBreakerChangedEvent>(OnBreakerChanged);
        SubscribeLocalEvent<StationAiApcControllableComponent, ActivatableUIOpenAttemptEvent>(OnUiOpenAttempt);
    }

    private void OnUiOpenAttempt(EntityUid uid, StationAiApcControllableComponent comp, ActivatableUIOpenAttemptEvent args)
    {
        // A IA só pode mexer na APC pelo menu radial (alt-clique), nunca pelo painel padrão de humano.
        if (HasComp<StationAiHeldComponent>(args.User))
            args.Cancel();
    }

    private void OnMapInit(EntityUid uid, StationAiApcControllableComponent comp, MapInitEvent args)
    {
        if (TryComp(uid, out ApcComponent? apc))
            SetPowerOn((uid, comp), apc.MainBreakerEnabled);
    }

    private void OnToggle(EntityUid uid, StationAiApcControllableComponent comp, StationAiApcToggleEvent args)
    {
        // Toggle puro do estado real; o espelhamento de PowerOn vem do ApcMainBreakerChangedEvent.
        _apc.ApcToggleBreaker(uid, user: args.User);
    }

    private void OnBreakerChanged(EntityUid uid, StationAiApcControllableComponent comp, ref ApcMainBreakerChangedEvent args)
    {
        SetPowerOn((uid, comp), args.On);
    }

    private void SetPowerOn(Entity<StationAiApcControllableComponent> ent, bool on)
    {
        if (ent.Comp.PowerOn == on)
            return;

        ent.Comp.PowerOn = on;
        Dirty(ent);
    }
}
