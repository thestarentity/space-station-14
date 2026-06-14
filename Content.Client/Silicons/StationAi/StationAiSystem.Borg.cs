using Content.Shared.Emag.Components;
using Content.Shared.Emag.Systems;
using Content.Shared.Silicons.Borgs.Components;
using Content.Shared.Silicons.StationAi;
using Robust.Shared.Utility;

namespace Content.Client.Silicons.StationAi;

public sealed partial class StationAiSystem
{
    [Dependency] private EmagSystem _emag = default!;

    // Ícones PLACEHOLDER (o usuário pode desenhar PNGs próprios depois e trocar estes caminhos):
    // subverter = cartão emag; desligar = "no-action" dos borgs; detonar = bomba cluster.
    private readonly ResPath _emagRsi = new ResPath("/Textures/Objects/Tools/emag.rsi");
    private readonly ResPath _borgActionsRsi = new ResPath("/Textures/Interface/Actions/actions_borg.rsi");
    private readonly ResPath _clusterbombRsi = new ResPath("/Textures/Objects/Weapons/Grenades/clusterbomb.rsi");

    private void InitializeBorg()
    {
        SubscribeLocalEvent<BorgChassisComponent, GetStationAiRadialEvent>(OnBorgGetRadial);
    }

    private void OnBorgGetRadial(Entity<BorgChassisComponent> ent, ref GetStationAiRadialEvent args)
    {
        // Trancar/Destrancar painel: disponível sob QUALQUER lei (defensivo ou ofensivo). Toggle.
        var locked = HasComp<StationAiBorgPanelLockComponent>(ent.Owner);
        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_aiActionsRsi, locked ? "unbolt_door" : "bolt_door"),
            Tooltip = Loc.GetString(locked ? "ai-borg-panel-unlock" : "ai-borg-panel-lock"),
            Event = new StationAiTogglePanelLockEvent { Lock = !locked },
        });

        // As demais (subverter/desligar/detonar) só aparecem sob lei hostil (o servidor reconfirma).
        if (!LocalAiIsHostile())
            return;

        // Subverter: some se o borg já estiver subvertido/emagado.
        if (!_emag.CheckFlag(ent.Owner, EmagType.Interaction))
        {
            args.Actions.Add(new StationAiRadial
            {
                Sprite = new SpriteSpecifier.Rsi(_emagRsi, "icon"),
                Tooltip = Loc.GetString("ai-borg-subvert"),
                Event = new StationAiSubvertBorgEvent(),
            });
        }

        // Desligar borg (ejeta o cérebro).
        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_borgActionsRsi, "no-action"),
            Tooltip = Loc.GetString("ai-borg-disable"),
            Event = new StationAiDisableBorgEvent(),
        });

        // Detonar borg (irreversível; confirma no servidor por duplo-clique).
        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_clusterbombRsi, "icon"),
            Tooltip = Loc.GetString("ai-borg-detonate"),
            Event = new StationAiDetonateBorgEvent(),
        });
    }
}
