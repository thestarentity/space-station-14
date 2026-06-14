using Content.Shared.Silicons.StationAi;
using Robust.Shared.Utility;

namespace Content.Client.Silicons.StationAi;

public sealed partial class StationAiSystem
{
    private void InitializeApc()
    {
        SubscribeLocalEvent<StationAiApcControllableComponent, GetStationAiRadialEvent>(OnApcGetRadial);
    }

    private void OnApcGetRadial(Entity<StationAiApcControllableComponent> ent, ref GetStationAiRadialEvent args)
    {
        var powerOn = ent.Comp.PowerOn;

        // Categoria APC: um único botão limpo — cortar ou restaurar a energia da área.
        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_aiCustomRsi, powerOn ? "turn_off" : "turn_on"),
            Tooltip = Loc.GetString(powerOn ? "ai-apc-power-off" : "ai-apc-power-on"),
            Event = new StationAiApcToggleEvent(),
        });
    }
}
