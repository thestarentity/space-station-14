using Content.Shared.Emag.Components;
using Content.Shared.Emag.Systems;
using Content.Shared.Silicons.Borgs.Components;
using Content.Shared.Silicons.StationAi;
using Robust.Shared.Utility;

namespace Content.Client.Silicons.StationAi;

public sealed partial class StationAiSystem
{
    [Dependency] private EmagSystem _emag = default!;

    // Placeholder: usa o ícone do cartão emag (tematicamente combina com "subverter").
    // O usuário pode desenhar um PNG próprio depois e trocar este caminho.
    private readonly ResPath _emagRsi = new ResPath("/Textures/Objects/Tools/emag.rsi");

    private void InitializeBorg()
    {
        SubscribeLocalEvent<BorgChassisComponent, GetStationAiRadialEvent>(OnBorgGetRadial);
    }

    private void OnBorgGetRadial(Entity<BorgChassisComponent> ent, ref GetStationAiRadialEvent args)
    {
        // Subverter só aparece sob lei hostil (o servidor reconfirma).
        if (!LocalAiIsHostile())
            return;

        // Já subvertido/emagado? não oferece de novo.
        if (_emag.CheckFlag(ent.Owner, EmagType.Interaction))
            return;

        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_emagRsi, "icon"),
            Tooltip = Loc.GetString("ai-borg-subvert"),
            Event = new StationAiSubvertBorgEvent(),
        });
    }
}
