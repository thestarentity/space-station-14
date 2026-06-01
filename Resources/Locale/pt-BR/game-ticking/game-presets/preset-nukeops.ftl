nukeops-title = Operativos Nucleares
nukeops-description = Operativos nucleares estão alvo da estação. Tente impedir que eles ativem e detonem a bomba nuclear protegendo o disco da bomba!
nukeops-welcome =
    Você é um operativo nuclear. Seu objetivo é destruir { $station } e garantir que fique apenas um monte de escombros. Seus patrões, o Sindicato, forneceram as ferramentas necessárias para a tarefa.
    Operação { $name } está em andamento! Morte à Nanotrasen!
nukeops-briefing = Seus objetivos são simples. Entregue a carga e saia antes que ela detonar. Iniciar missão.
nukeops-opsmajor = [color=crimson]Vitória importante do Sindicato![/color]
nukeops-opsminor = [color=crimson]Vitória menor do Sindicato![/color]
nukeops-neutral = [color=yellow]Resultado neutro![/color]
nukeops-crewminor = [Vitória de tripulante menor!]
nukeops-crewmajor = [Vitória maior da tripulação!]
nukeops-cond-nukeexplodedoncorrectstation = Os operativos nucleares conseguiram destruir a estação.
nukeops-cond-nukeexplodedonnukieoutpost = O posto avançado operativo nuclear foi destruído por uma explosão nuclear!
nukeops-cond-nukeexplodedonincorrectlocation = A bomba nuclear detonou fora da estação.
nukeops-cond-nukeactiveinstation = A bomba nuclear foi deixada armada na estação.
nukeops-cond-nukeactiveatcentcom = A bomba nuclear foi armada e entregue ao Comando Central!
nukeops-cond-nukediskoncentcom = A tripulação escapou com o disco de autenticação nuclear.
nukeops-cond-nukedisknotoncentcom = A tripulação deixou o disco de autenticação nuclear para trás.
nukeops-cond-nukiesabandoned = Os operativos nucleares foram abandonados.
nukeops-cond-allnukiesdead = Todos os operativos nucleares morreram.
nukeops-cond-somenukiesalive = Alguns operativos nucleares morreram.
nukeops-cond-allnukiesalive = Nenhum operativo nuclear morreu.
nukeops-disk-location-title = Localização final do disco:
nukeops-disk-carried-by =
    { " " }carregado por [color=White]{ $name }[/color], [color=orange]{ $job }[/color], { $location } { $user ->
        [unknown] { "" }
       *[other] ([color=gray]{ $user }[/color])
    }
storage-hierarchy-list =
    { $items-left ->
        [0] { $existing-text } { $item },
       *[other] { $existing-text } { $item }, em
    }
nukeops-list-start = Os operativos nucleares foram:
nukeops-list-name = - [color=White]{ $name }[/color]
nukeops-list-name-user = - [color=White]{ $name }[/color] ([color=gray]{ $user }[/color])
nukeops-not-enough-ready-players = Não há jogadores suficientes preparados para o jogo! Havia { $readyPlayersCount } jogadores preparados de um total de { $minimumPlayers } necessário. Não é possível iniciar o Nukeops.
nukeops-no-one-ready = Nenhum jogador se preparou! Não é possível iniciar Nukeops.
nukeops-role-commander = Comandante
nukeops-role-agent = Médico
nukeops-role-operator = Operador
