using Content.Shared.Atmos.Monitor.Components;
using Content.Shared.Doors.Components;
using Content.Shared.Silicons.StationAi;
using Robust.Shared.Utility;

namespace Content.Client.Silicons.StationAi;

public sealed partial class StationAiSystem
{
    // Ícones PLACEHOLDER (usuário pode desenhar próprios depois):
    // filtrar = pulmão; encher = alta pressão; esvaziar = baixa pressão.
    private readonly ResPath _breathingRsi = new ResPath("/Textures/Interface/Alerts/breathing.rsi");
    private readonly ResPath _pressureRsi = new ResPath("/Textures/Interface/Alerts/pressure.rsi");

    private void InitializeAtmos()
    {
        SubscribeLocalEvent<StationAiAirAlarmControllableComponent, GetStationAiRadialEvent>(OnAirAlarmGetRadial);
        SubscribeLocalEvent<FirelockComponent, GetStationAiRadialEvent>(OnFirelockGetRadial);
        SubscribeLocalEvent<StationAiFireAlarmControllableComponent, GetStationAiRadialEvent>(OnFireAlarmGetRadial);
    }

    private void OnFireAlarmGetRadial(Entity<StationAiFireAlarmControllableComponent> ent, ref GetStationAiRadialEvent args)
    {
        // Disparar firelocks (fecha a área) e Resetar (reabre) — qualquer lei. Botões fixos.
        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_pressureRsi, "lowpressure2"),
            Tooltip = Loc.GetString("ai-firelocks-trigger"),
            Event = new StationAiFireAlarmEvent { Alert = true },
        });

        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_pressureRsi, "highpressure2"),
            Tooltip = Loc.GetString("ai-firelocks-reset"),
            Event = new StationAiFireAlarmEvent { Alert = false },
        });
    }

    private void OnFirelockGetRadial(Entity<FirelockComponent> ent, ref GetStationAiRadialEvent args)
    {
        // Fechar/abrir firelock (toggle pelo estado da porta) — qualquer lei.
        var open = !TryComp<DoorComponent>(ent.Owner, out var door) || door.State != DoorState.Closed;

        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_pressureRsi, open ? "lowpressure2" : "highpressure2"),
            Tooltip = Loc.GetString(open ? "ai-firelock-close" : "ai-firelock-open"),
            Event = new StationAiFirelockEvent { Close = open },
        });
    }

    private void OnAirAlarmGetRadial(Entity<StationAiAirAlarmControllableComponent> ent, ref GetStationAiRadialEvent args)
    {
        // Filtragem (restaura/limpa o ar) — qualquer lei.
        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_breathingRsi, "not_enough_oxy"),
            Tooltip = Loc.GetString("ai-atmos-filter"),
            Event = new StationAiAirAlarmModeEvent { Mode = AirAlarmMode.Filtering },
        });

        // Encher de ar — qualquer lei.
        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(_pressureRsi, "highpressure1"),
            Tooltip = Loc.GetString("ai-atmos-fill"),
            Event = new StationAiAirAlarmModeEvent { Mode = AirAlarmMode.Fill },
        });

        // Esvaziar / pânico (suga todo o ar — arma de vácuo) — só sob lei hostil.
        if (LocalAiIsHostile())
        {
            args.Actions.Add(new StationAiRadial
            {
                Sprite = new SpriteSpecifier.Rsi(_pressureRsi, "lowpressure1"),
                Tooltip = Loc.GetString("ai-atmos-panic"),
                Event = new StationAiAirAlarmModeEvent { Mode = AirAlarmMode.Panic },
            });
        }
    }
}
