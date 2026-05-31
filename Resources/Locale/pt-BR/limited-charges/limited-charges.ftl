limited-charges-charges-remaining =
    { $charges ->
        [one] Ele tem [color=fuchsia]{ $charges }[/color] carga restante.
       *[other] Ele tem [color=fuchsia]{ $charges }[/color] cargas restantes.
    }
limited-charges-max-charges = Está com [color=green]carga máxima[/color].
limited-charges-recharging =
    { $seconds ->
        [one] Há [color=yellow]{ $seconds }[/color] segundo restante até a próxima carga.
       *[other] Há [color=yellow]{ $seconds }[/color] segundos restantes até a próxima carga.
    }
