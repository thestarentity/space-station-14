using Content.Shared.Emag.Systems;
using Content.Shared.Mind;
using Content.Shared.Overlays;
using Content.Shared.Popups;
using Content.Shared.Silicons.Laws.Components;
using Content.Shared.Silicons.StationAi;
using Content.Shared.Stunnable;
using Content.Shared.Wires;
using Robust.Shared.Audio;

namespace Content.Shared.Silicons.Laws;

/// <summary>
/// This handles getting and displaying the laws for silicons.
/// </summary>
public abstract partial class SharedSiliconLawSystem : EntitySystem
{
    [Dependency] private SharedPopupSystem _popup = default!;
    [Dependency] private SharedStunSystem _stunSystem = default!;
    [Dependency] private EmagSystem _emag = default!;
    [Dependency] private SharedMindSystem _mind = default!;

    /// <inheritdoc/>
    public override void Initialize()
    {
        InitializeUpdater();
        SubscribeLocalEvent<EmagSiliconLawComponent, GotEmaggedEvent>(OnGotEmagged);
    }

    private void OnGotEmagged(EntityUid uid, EmagSiliconLawComponent component, ref GotEmaggedEvent args)
    {
        if (!_emag.CompareFlag(args.Type, EmagType.Interaction))
            return;

        if (_emag.CheckFlag(uid, EmagType.Interaction))
            return;

        // prevent self-emagging
        if (uid == args.UserUid)
        {
            _popup.PopupClient(Loc.GetString("law-emag-cannot-emag-self"), uid, args.UserUid);
            return;
        }

        // A IA de estação subverte o borg à distância (pelo menu radial), então não exige
        // painel de fios aberto — diferente de um humano usando um cartão emag na mão.
        if (component.RequireOpenPanel &&
            !HasComp<StationAiHeldComponent>(args.UserUid) &&
            TryComp<WiresPanelComponent>(uid, out var panel) &&
            !panel.Open)
        {
            _popup.PopupClient(Loc.GetString("law-emag-require-panel"), uid, args.UserUid);
            return;
        }

        var ev = new SiliconEmaggedEvent(args.UserUid);
        RaiseLocalEvent(uid, ref ev);

        component.OwnerName = Name(args.UserUid);

        NotifyLawsChanged(uid, component.EmaggedSound);
        if(_mind.TryGetMind(uid, out var mindId, out _))
            EnsureSubvertedSiliconRole(mindId);

        _stunSystem.TryUpdateParalyzeDuration(uid, component.StunTime);

        args.Handled = true;
    }

    public virtual void NotifyLawsChanged(EntityUid uid, SoundSpecifier? cue = null)
    {
        // Hook para sistemas reagirem a mudança de leis (ex.: ações hostis da IA de estação).
        var ev = new SiliconLawsUpdatedEvent();
        RaiseLocalEvent(uid, ref ev);
    }

    protected virtual void EnsureSubvertedSiliconRole(EntityUid mindId)
    {
        if (TryComp<MindComponent>(mindId, out var mind))
        {
            var owner = mind.OwnedEntity;
            if (TryComp<ShowCrewIconsComponent>(owner, out var crewIconComp))
            {
                crewIconComp.UncertainCrewBorder = true;
                Dirty(owner.Value, crewIconComp);
            }
        }
    }

    protected virtual void RemoveSubvertedSiliconRole(EntityUid mindId)
    {
        if (TryComp<MindComponent>(mindId, out var mind))
        {
            var owner = mind.OwnedEntity;
            if (TryComp<ShowCrewIconsComponent>(owner, out var crewIconComp))
            {
                crewIconComp.UncertainCrewBorder = false;
                Dirty(owner.Value, crewIconComp);
            }
        }
    }
}

[ByRefEvent]
public record struct SiliconEmaggedEvent(EntityUid user);
