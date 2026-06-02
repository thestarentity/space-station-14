guidebook-reagent-effect-description =
    { $quantity ->
        [0] { "" }
       *[other] Se houver pelo menos { $quantity }u { $reagent },{ " " }
    }{ $chance ->
        [1] { $effect }
       *[other] Tem uma chance de { NATURALPERCENT($chance, 2) } para { $effect }
    }{ $conditionCount ->
        [0] .
       *[other] { " " }quando { $conditions }.
    }
guidebook-reagent-name = [bold][color={ $color }]{ CAPITALIZE($name) }[/color][/bold]
guidebook-reagent-recipes-header = Receita
guidebook-reagent-recipes-reagent-display = [bold]{ $reagent }[/bold] \[{ $ratio }\]
guidebook-reagent-sources-header = Fontes
guidebook-reagent-sources-ent-wrapper = [bold]{ $name }[/bold] \[1\]
guidebook-reagent-sources-gas-wrapper = [bold]{ $name } (gás)[/bold] \[1\]
guidebook-reagent-effects-header = Efeitos
guidebook-reagent-effects-metabolism-stage-rate = [bold]{ $stage }[/bold] [color=gray]({ $rate } unidades por segundo)[/color]
guidebook-reagent-effects-metabolite-item = { $reagent } a uma taxa de { NATURALPERCENT($rate, 2) }
guidebook-reagent-effects-metabolites = Metaboliza-se em { $items }.
guidebook-reagent-plant-metabolisms-header = Metabolismo da Planta
guidebook-reagent-plant-metabolisms-rate = [bold]Metabolismo da Planta[/bold] [color=gray](1 unidade a cada 3 segundos como base)[/color]
guidebook-reagent-physical-description = [italic]Parece ser { $description }.[/italic]
guidebook-reagent-recipes-mix-info =
    { $minTemp ->
        [0]
            { $hasMax ->
                [true] { CAPITALIZE($verb) } abaixo { NATURALFIXED($maxTemp, 2) }K
               *[false] { CAPITALIZE($verb) }
            }
       *[other]
            { CAPITALIZE($verb) } { $hasMax ->
                [true] entre { NATURALFIXED($minTemp, 2) }K e { NATURALFIXED($maxTemp, 2) }K
               *[false] Acima de { NATURALFIXED($minTemp, 2) }K
            }
    }
