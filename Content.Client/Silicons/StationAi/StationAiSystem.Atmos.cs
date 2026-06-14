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
        var mode = ent.Comp.CurrentMode;

        // Modos (o ativo ganha um "✓" no tooltip — feedback de qual está rodando).
        AddMode(args.Actions, mode, AirAlarmMode.Filtering, _breathingRsi, "not_enough_oxy", "ai-atmos-filter");
        AddMode(args.Actions, mode, AirAlarmMode.Fill, _pressureRsi, "highpressure1", "ai-atmos-fill");

        if (LocalAiIsHostile())
        {
            // Esvaziar/pânico (vácuo inescapável: suga o ar + tranca airlocks; persiste até filtrar).
            AddMode(args.Actions, mode, AirAlarmMode.Panic, _pressureRsi, "lowpressure1", "ai-atmos-panic");

            // Travar setor (lockdown): airlocks com ferrolho + firelocks fechados.
            args.Actions.Add(new StationAiRadial
            {
                Sprite = new SpriteSpecifier.Texture(new ResPath("/Textures/Interface/VerbIcons/lock-red.svg.192dpi.png")),
                Tooltip = Loc.GetString("ai-atmos-lockdown"),
                Event = new StationAiAtmosLockdownEvent { Lock = true },
            });
        }

        // Destravar setor (liberar) — qualquer lei (soltar a trava é seguro).
        args.Actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Texture(new ResPath("/Textures/Interface/VerbIcons/lock.svg.192dpi.png")),
            Tooltip = Loc.GetString("ai-atmos-unlock"),
            Event = new StationAiAtmosLockdownEvent { Lock = false },
        });
    }

    private void AddMode(List<StationAiRadial> actions, AirAlarmMode current, AirAlarmMode mode, ResPath rsi, string state, string locKey)
    {
        var label = Loc.GetString(locKey);
        if (current == mode)
            label += " ✓";

        actions.Add(new StationAiRadial
        {
            Sprite = new SpriteSpecifier.Rsi(rsi, state),
            Tooltip = label,
            Event = new StationAiAirAlarmModeEvent { Mode = mode },
        });
    }
}
