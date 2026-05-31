## UI

injector-volume-transfer-label =
    Volume: [color=white]{ $currentVolume }/{ $totalVolume }u[/color]
    Modo: [color=white]{ $modeString }[/color] ([color=white]{ $transferVolume }u[/color])
injector-volume-label =
    Volume: [color=white]{ $currentVolume }/{ $totalVolume }u[/color]
    Modo: [color=white]{ $modeString }[/color]
injector-toggle-verb-text = Alternar Modo de Injetor

## Entity

injector-component-inject-mode-name = Injetar
injector-component-draw-mode-name = Desenhar
injector-component-dynamic-mode-name = Modo Dinâmico
injector-component-mode-changed-text = Agora { $mode }
injector-component-transfer-success-message = Você transfere { $amount }u para { THE($target) }.
injector-component-transfer-success-message-self = Você transfere { $amount }u em si mesmo.
injector-component-inject-success-message = Você injeta { $amount }u em { THE($target) }!
injector-component-inject-success-message-self = Você injeta { $amount }u em si mesmo!
injector-component-draw-success-message = Você desenha { $amount }u de { THE($target) }.
injector-component-draw-success-message-self = Você retira { $amount }u de si mesmo.

## Fail Messages

injector-component-target-already-full-message = { CAPITALIZE(THE($target)) } já está cheio!
injector-component-target-already-full-message-self = Você já está cheio!
injector-component-target-is-empty-message = { CAPITALIZE(THE($target)) } está vazio!
injector-component-target-is-empty-message-self = Você está vazio!
injector-component-cannot-toggle-draw-message = Muito cheio para desenhar!
injector-component-cannot-toggle-inject-message = Nada para injetar!
injector-component-cannot-toggle-dynamic-message = Não pode alternar dinâmico!
injector-component-empty-message = { CAPITALIZE(THE($injector)) } está vazio!
injector-component-blocked-user = O equipamento de proteção bloqueou sua injeção!
injector-component-blocked-other = { CAPITALIZE(THE(POSS-ADJ($target))) } armadura bloqueou a injeção de { THE($user) }!
injector-component-cannot-transfer-message = Você não consegue transferir para { THE($target) }!
injector-component-cannot-transfer-message-self = Você não consegue se transferir para si mesmo!
injector-component-cannot-inject-message = Você não consegue injetar em { THE($target) }!
injector-component-cannot-inject-message-self = Você não consegue injetar em si mesmo!
injector-component-cannot-draw-message = Você não consegue tirar de { THE($target) }!
injector-component-cannot-draw-message-self = Você não consegue se injetar!
injector-component-ignore-mobs = Este injetor só pode interagir com recipientes!

## mob-inject doafter messages

injector-component-needle-injecting-user = Você começa a injetar a agulha.
injector-component-needle-injecting-target = { CAPITALIZE(THE($user)) } está tentando injetar uma agulha em você!
injector-component-needle-drawing-user = Você começa a desenhar a agulha.
injector-component-needle-drawing-target = { CAPITALIZE(THE($user)) } está tentando usar uma agulha para extrair algo de você!
injector-component-spray-injecting-user = Você começa a preparar a mangueira de pulverização.
injector-component-spray-injecting-target = { CAPITALIZE(THE($user)) } está tentando colocar uma mangueira de spray em você!

## Target Popup Success messages

injector-component-feel-prick-message = Você sente uma picada minúscula!
