## Rev Head

roles-antag-rev-head-name = Chefe Revolucionário
roles-antag-rev-head-objective = Sua objetiva é tomar conta da estação convertendo pessoas para sua causa e eliminando todos os membros do Comando.
head-rev-role-greeting =
    Você é um líder revolucionário. Sua tarefa é remover todos do Comando do poder por meio da morte, da restrição ou da conversão.
    O Sindicato patrocinou você com um flash que converte outros para sua causa. Cuidado, isso não funcionará em quem tiver proteção ocular ou implantes de mindshield. Lembre-se de que o Comando e a Segurança são implantados com mindshields como parte do processo de contratação.
    Viva a revolução!
head-rev-briefing =
    Use flashes para converter pessoas ao seu lado.
    Mata, restringe ou converte todos os membros do Comando para tomar conta da estação.
head-rev-break-mindshield = O implante de mindshield foi destruído!

## Rev

roles-antag-rev-name = Revolucionário
roles-antag-rev-objective = Sua objetiva é garantir a segurança e seguir as ordens dos chefes revolucionários, e ajudá-los a tomar a estação eliminando todos os membros do Comando.
rev-break-control = { $name } lembrou-se de sua verdadeira lealdade!
rev-role-greeting =
    Você é um revolucionário. Sua tarefa é proteger os líderes da revolução e ajudá-los a tomar conta da estação.
    A revolução deve trabalhar juntos para matar, restringir ou converter todos os membros do Comando.
    Viva a revolução!
rev-briefing = Ajude os líderes da revolução a matar, imobilizar ou converter todos os membros do Comando para tomar conta da estação.

## General

rev-title = Revolucionários
rev-description = Revolutionários escondidos entre a tripulação estão tentando converter outros para sua causa e derrubar o Comando.
rev-not-enough-ready-players = Não há jogadores suficientes prontos para o jogo. Havia { $readyPlayersCount } jogadores prontos de { $minimumPlayers } necessários. Não é possível iniciar os Revolucionários.
rev-no-one-ready = Nenhum jogador se preparou! Não é possível iniciar os Revolucionários.
rev-no-heads = Não havia líderes da Revolução para serem selecionados. Não é possível iniciar a Revolução.
rev-won = Os líderes revolucionários sobreviveram e conseguiram tomar o controle da estação.
rev-lost = Todos os líderes da revolução foram mortos, e o Comando sobreviveu.
rev-stalemate = Ambos o Comando e o líder dos revolucionários estão mortos. É um empate.
rev-reverse-stalemate = Ambos o Comando e o chefe dos revolucionários sobreviveram.
rev-headrev-count =
    { $initialCount ->
        [one] Havia um único revolucionário de cabeça:
       *[other] Havia { $initialCount } revolucionários de cabeça:
    }
rev-headrev-name-user = [color=#5e9cff]{ $name }[/color] ([color=gray]{ $username }[/color]) convertido { $count }{ $count ->
        [one] pessoa
       *[other] pessoas
    }
rev-headrev-name = [color=#5e9cff]{ $name }[/color] convertido { $count }{ $count ->
        [one] pessoa
       *[other] pessoas
    }

## Deconverted window

rev-deconverted-title = Desconvertido!
rev-deconverted-text =
    Com o último chefe revolucionário morto, a revolução acabou.
    
    Você não é mais um revolucionário, então seja gentil.
rev-deconverted-confirm = Confirmar
