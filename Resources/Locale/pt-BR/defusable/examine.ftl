defusable-examine-defused = { CAPITALIZE(THE($name)) } está [color=lime]desarmado[/color].
defusable-examine-live = { CAPITALIZE(THE($name)) } está [color=red]ticking[/color] e tem [color=red]{ $time }[/color] segundos restantes.
defusable-examine-live-display-off = { CAPITALIZE(THE($name)) } está [color=red]ticking[/color], e o temporizador parece estar desligado.
defusable-examine-inactive = { CAPITALIZE(THE($name)) } está [color=lime]inativo[/color], mas ainda pode ser armado.
defusable-examine-bolts =
    Os parafusos são { $down ->
        [true] para baixo
       *[false] [color=verde]cima[/color]
    }A bolta parece estar solta. Você pode tentar apertá-la com uma ferramenta de manutenção.
