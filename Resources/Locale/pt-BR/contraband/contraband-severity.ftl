contraband-examine-text-Minor =
    { $type ->
       *[item] [color={ $color }]Este item é considerado contrabando menor.[/color]
        [reagent] [color={ $color }]Este reagente é considerado contrabando menor.[/color]
    }
contraband-examine-text-Restricted =
    { $type ->
       *[item] [color={ $color }]Este item está restrito ao departamento.[/color]
        [reagent] [color={ $color }]Este reagente é restrito ao departamento.[/color]
    }
contraband-examine-text-Restricted-department =
    { $type ->
       *[item] [color={ $color }]Este item é restrito a { $departments } e pode ser considerado contrabando.[/color]
        [reagent] [color={ $color }]Este reagente é restrito a { $departments } e pode ser considerado contrabando.[/color]
    }
contraband-examine-text-Major =
    { $type ->
       *[item] [color={ $color }]Este item é considerado contrabando de alto nível.[/color]
        [reagent] [color={ $color }]Este reagente é considerado contrabando de alto nível.[/color]
    }
contraband-examine-text-GrandTheft =
    { $type ->
       *[item] [color={ $color }]Este item é um alvo altamente valioso para agentes do Sindicato![/color]
        [reagent] [color={ $color }]Este reagente é um alvo altamente valioso para agentes do Sindicato![/color]
    }
contraband-examine-text-Highly-Illegal =
    { $type ->
       *[item] [color={ $color }]Este item é contrabando altamente ilegal![/color]
        [reagent] [color={ $color }]Este reagente é contrabando altamente ilegal![/color]
    }
contraband-examine-text-Syndicate =
    { $type ->
       *[item] [color={ $color }]Este item é contrabando altamente ilegal do Sindicato![/color]
        [reagent] [color={ $color }]Este reagente é uma contrabando altamente ilegal do Sindicato![/color]
    }
contraband-examine-text-Magical =
    { $type ->
       *[item] [color={ $color }]Este item é contrabando mágico altamente ilegal![/color]
        [reagent] [color={ $color }]Este reagente é uma substância mágica altamente ilegal![/color]
    }
contraband-examine-text-avoid-carrying-around = [color=red][italic]Você provavelmente quer evitar carregar isso visivelmente por aí sem uma boa razão.[/italic][/color]
contraband-examine-text-in-the-clear = [color=verde][itálico]Você deve estar em segurança para carregar isso visivelmente.[/itálico][/color]
contraband-examinable-verb-text = Legalidade
contraband-examinable-verb-message = Verifique a legalidade deste item.
contraband-department-plural = { $department }
contraband-job-plural = { MAKEPLURAL($job) }
