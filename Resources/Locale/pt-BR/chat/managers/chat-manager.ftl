### UI

chat-manager-max-message-length = Sua mensagem excede o limite de { $maxMessageLength } caracteres
chat-manager-ooc-chat-enabled-message = OOC chat has been enabled.
chat-manager-ooc-chat-disabled-message = OOC chat has been disabled.
chat-manager-looc-chat-enabled-message = O chat LOOC foi ativado.
chat-manager-looc-chat-disabled-message = O chat LOOC foi desabilitado.
chat-manager-dead-looc-chat-enabled-message = Jogadores mortos podem agora usar LOOC.
chat-manager-dead-looc-chat-disabled-message = Jogadores mortos não podem mais usar LOOC.
chat-manager-crit-looc-chat-enabled-message = Jogadores Crit podem agora usar LOOC.
chat-manager-crit-looc-chat-disabled-message = Os jogadores Críticos não podem mais usar o LOOC.
chat-manager-admin-ooc-chat-enabled-message = O chat OOC do administrador foi ativado.
chat-manager-admin-ooc-chat-disabled-message = O chat OOC do administrador foi desativado.
chat-manager-max-message-length-exceeded-message = Sua mensagem excedeu o limite de { $limit } caracteres
chat-manager-no-headset-on-message = Você não está usando um headset!
chat-manager-no-radio-key = Nenhuma chave de rádio especificada!
chat-manager-no-such-channel = Não existe um canal com a chave '{ $key }'!
chat-manager-whisper-headset-on-message = Você não pode sussurrar no rádio!
chat-manager-server-wrap-message = [bold]{ $message }[/bold]
chat-manager-sender-announcement = Comando Central
chat-manager-sender-announcement-wrap-message = [font size=14][bold]{ $sender } Anúncio:[/font][font size=12]
    { $message }[/bold][/font]
chat-manager-entity-say-wrap-message = [BubbleHeader][bold][Name]{ $entityName }[/Name][/bold][/BubbleHeader] { $verb }, [font={ $fontType } size={ $fontSize }]“[BubbleContent]{ $message }[/BubbleContent]”[/font]
chat-manager-entity-say-bold-wrap-message = [BubbleHeader][bold][Name]{ $entityName }[/Name][/bold][/BubbleHeader] { $verb }, [font={ $fontType } size={ $fontSize }]“[BubbleContent][bold]{ $message }[/bold][/BubbleContent]”[/font]
chat-manager-entity-whisper-wrap-message = [font size=11][italic][BubbleHeader][Nome]{ $entityName }[/Nome][/BubbleHeader] sussurra,“[BubbleContent]{ $message }[/BubbleContent]”[/italic][/font]
chat-manager-entity-whisper-unknown-wrap-message = [font size=11][italic][BubbleHeader]Alguém[/BubbleHeader] sussurra, “[BubbleContent]{ $message }[/BubbleContent]”[/italic][/font]
# THE() is not used here because the entity and its name can technically be disconnected if a nameOverride is passed...
chat-manager-entity-me-wrap-message = [italic]{ PROPER($entity) ->
       *[false] O { $entityName } { $message }[/italic]
        [true] { CAPITALIZE($entityName) } { $message }[/italic]
    }
chat-manager-entity-looc-wrap-message = LOOC: [bold]{ $entityName }:[/bold] { $message }
chat-manager-send-ooc-wrap-message = OOC: [bold]{ $playerName }:[/bold] { $message }
chat-manager-send-ooc-patron-wrap-message = OOC: [bold][color={ $patronColor }]{ $playerName }[/color]:[/bold] { $message }
chat-manager-send-dead-chat-wrap-message = { $deadChannelName }: [bold][BubbleHeader]{ $playerName }[/BubbleHeader]:[/bold] [BubbleContent]{ $message }[/BubbleContent]
chat-manager-send-admin-dead-chat-wrap-message = { $adminChannelName }: [bold]([BubbleHeader]{ $userName }[/BubbleHeader]):[/bold] [BubbleContent]{ $message }[/BubbleContent]
chat-manager-send-admin-chat-wrap-message = { $adminChannelName }: [bold]{ $playerName }:[/bold] { $message }
chat-manager-send-admin-announcement-wrap-message = [bold]{ $adminChannelName }: { $message }[/bold]
chat-manager-send-hook-ooc-wrap-message = OOC: [bold](D){ $senderName }:[/bold] { $message }
chat-manager-send-hook-admin-wrap-message = ADMIN: [bold](D){ $senderName }:[/bold] { $message }
chat-manager-dead-channel-name = MORTO
chat-manager-admin-channel-name = ADMIN
chat-manager-rate-limited = Você está enviando mensagens com muita rapidez!
chat-manager-rate-limit-admin-announcement = Aviso de limite de taxa: { $player }

## Speech verbs for chat

chat-speech-verb-suffix-exclamation = !
chat-speech-verb-suffix-exclamation-strong = !!
chat-speech-verb-suffix-question = ?
chat-speech-verb-suffix-stutter = -
chat-speech-verb-suffix-mumble = ..
chat-speech-verb-name-none = Nenhum
chat-speech-verb-name-default = Padrão
chat-speech-verb-default = diz
chat-speech-verb-name-exclamation = Ah!
chat-speech-verb-exclamation = exclama
chat-speech-verb-name-exclamation-strong = Gritando
chat-speech-verb-exclamation-strong = grita
chat-speech-verb-name-question = Perguntando
chat-speech-verb-question = pergunta
chat-speech-verb-name-stutter = Tremulação
chat-speech-verb-stutter = stutters
chat-speech-verb-name-mumble = Murmurando
chat-speech-verb-mumble = murmura
chat-speech-verb-name-arachnid = Aranha
chat-speech-verb-insect-1 = Cicadas.
chat-speech-verb-insect-2 = cicatriza
chat-speech-verb-insect-3 = cliques
chat-speech-verb-name-moth = Moth
chat-speech-verb-winged-1 = voa
chat-speech-verb-winged-2 = Aba
chat-speech-verb-winged-3 = zumbi
chat-speech-verb-name-slime = Bolacha
chat-speech-verb-slime-1 = escorrega
chat-speech-verb-slime-2 = Burbles
chat-speech-verb-slime-3 = escorrega
chat-speech-verb-name-plant = Diona
chat-speech-verb-plant-1 = esfrega
chat-speech-verb-plant-2 = balança
chat-speech-verb-plant-3 = crista
chat-speech-verb-name-robotic = Robótico
chat-speech-verb-robotic-1 = estados
chat-speech-verb-robotic-2 = Bips
chat-speech-verb-robotic-3 = Bips
chat-speech-verb-name-reptilian = Reptiliano
chat-speech-verb-reptilian-1 = sussurra
chat-speech-verb-reptilian-2 = rasteja
chat-speech-verb-reptilian-3 = Bufa
chat-speech-verb-name-skeleton = Esqueleto
chat-speech-verb-skeleton-1 = Rapariga
chat-speech-verb-skeleton-2 = clacks
chat-speech-verb-skeleton-3 = rangeia os dentes
chat-speech-verb-name-vox = Vox
chat-speech-verb-vox-1 = gritos
chat-speech-verb-vox-2 = gritos
chat-speech-verb-vox-3 = croaca
chat-speech-verb-name-canine = Cachorro
chat-speech-verb-canine-1 = latidos
chat-speech-verb-canine-2 = uau!
chat-speech-verb-canine-3 = uiva
chat-speech-verb-name-goat = Bode
chat-speech-verb-goat-1 = balidos
chat-speech-verb-goat-2 = grunhos
chat-speech-verb-goat-3 = chora
chat-speech-verb-name-sheep = Carneiro
chat-speech-verb-sheep-1 = balidos
chat-speech-verb-sheep-2 = baa
chat-speech-verb-name-small-mob = Rato
chat-speech-verb-small-mob-1 = squiqueiros
chat-speech-verb-small-mob-2 = pieps
chat-speech-verb-name-large-mob = Carp
chat-speech-verb-large-mob-1 = rugido
chat-speech-verb-large-mob-2 = rúgias
chat-speech-verb-name-monkey = Macaco
chat-speech-verb-monkey-1 = Chimpanzés
chat-speech-verb-monkey-2 = gritos
chat-speech-verb-name-cluwne = Palhaço
chat-speech-verb-name-parrot = Papagaio
chat-speech-verb-parrot-1 = squawks
chat-speech-verb-parrot-2 = Okay, I'll repeat what you said.
chat-speech-verb-parrot-3 = cicatriza
chat-speech-verb-cluwne-1 = risos
chat-speech-verb-cluwne-2 = rsrsrs
chat-speech-verb-cluwne-3 = rsrs
chat-speech-verb-name-ghost = Fantasma
chat-speech-verb-ghost-1 = reclama
chat-speech-verb-ghost-2 = respira
chat-speech-verb-ghost-3 = hummmmm...
chat-speech-verb-ghost-4 = sussurra
chat-speech-verb-name-electricity = Eletricidade
chat-speech-verb-electricity-1 = crepita
chat-speech-verb-electricity-2 = zumbi
chat-speech-verb-electricity-3 = gritos
chat-speech-verb-vulpkanin-1 = rawrs
chat-speech-verb-vulpkanin-2 = latidos
chat-speech-verb-vulpkanin-3 = Rurs
chat-speech-verb-vulpkanin-4 = Latido
chat-speech-verb-vulpkanin = Vulpkanin
chat-speech-verb-name-wawa = Wawa
chat-speech-verb-wawa-1 = intones
chat-speech-verb-wawa-2 = estados
chat-speech-verb-wawa-3 = declara
chat-speech-verb-wawa-4 = medita
