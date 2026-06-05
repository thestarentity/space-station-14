point-scoreboard-winner = O vencedor foi [color=lime]{ $player }![/color]
point-scoreboard-header = [bold]Quadro de Pontuação[/bold]
point-scoreboard-list =
    { $place }. [bold][color=cyan]{ $name }[/color][/bold] pontuou [color=yellow]{ $points ->
        [one] { $points } ponto
       *[other] { $points } pontos
    }[/color].
