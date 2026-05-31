## Survivor

roles-antag-survivor-name = Sobrevivente
# It's a Halo reference
roles-antag-survivor-objective = Objetivo atual: Sobreviver
survivor-role-greeting =
    Você é um Sobrevivente. Acima de tudo, você precisa voltar ao Comando Central com vida.
    Colete tanto poder de fogo quanto necessário para garantir sua sobrevivência.
    Não confie em ninguém.
survivor-round-end-dead-count =
    { $deadCount ->
        [one] [color=red]{ $deadCount }[/color] sobrevivente morreu.
       *[other] { $deadCount } sobreviventes morreram.
    }
survivor-round-end-alive-count =
    { $aliveCount ->
        [one] [color=yellow]{ $aliveCount }[/color] sobrevivente foi deixado para trás na estação.
       *[other] [color=yellow]{ $aliveCount }[/color] sobreviventes foram deixados à mercê da estação.
    }
survivor-round-end-alive-on-shuttle-count =
    { $aliveCount ->
        [one] [color=green]{ $aliveCount }[/color] sobrevivente conseguiu sair vivo.
       *[other] [color=green]{ $aliveCount }[/color] sobreviventes conseguiram sair vivos.
    }

## Wizard

objective-issuer-swf = [color=turquoise]A Federação de Mágicos Espaciais[/color]
wizard-title = Feiticeiro
wizard-description = Tem um Mágico na estação! Você nunca sabe o que ele pode fazer.
roles-antag-wizard-name = Feiticeiro
roles-antag-wizard-objective = Ensine-lhes uma lição que nunca vão esquecer.
wizard-role-greeting =
    É hora do bruxo, bola de fogo!
    Houve tensões entre a Federação dos Bruxos do Espaço e a Nanotrasen. Você foi selecionado pela Federação dos Bruxos do Espaço para visitar a estação e "lembrá-los" por que bruxos não devem ser subestimados.
    Causar caos e destruição! O que você fizer é sua escolha, mas lembre-se de que os Bruxos do Espaço querem que você saia vivo.
wizard-round-end-name = Bruxo

## TODO: Wizard Apprentice (Coming sometime post-wizard release)

