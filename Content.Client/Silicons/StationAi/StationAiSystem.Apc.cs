using Content.Shared.Silicons.StationAi;
using Robust.Shared.Utility;

namespace Content.Client.Silicons.StationAi;

public sealed partial class StationAiSystem
{
    private readonly ResPath _apcRsi = new ResPath("/Textures/Structures/Power/apc.rsi");

    private void InitializeApc()
    {
        SubscribeLocalEvent<StationAiApcControllableComponent, GetStationAiRadialEvent>(OnApcGetRadial);
    }

    private void OnApcGetRadial(Entity<StationAiApcControllableComponent> ent, ref GetStationAiRadialEvent args)
    {
        var powerOn = ent.Comp.PowerOn;

        // Categoria APC: um único botão limpo — cortar ou restaurar a energia da área.
        // Ícone usa o display da própria APC (vermelho = sem energia, verde = energia restaurada).
        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_apcRsi, powerOn ? "display-lack" : "display-full"),
            Tooltip = Loc.GetString(powerOn ? "ai-apc-power-off" : "ai-apc-power-on"),
            Event = new StationAiApcToggleEvent(),
        });
    }
}
