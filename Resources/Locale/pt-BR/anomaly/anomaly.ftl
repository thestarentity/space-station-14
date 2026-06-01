anomaly-component-contact-damage = A anomalia queima sua pele!
anomaly-vessel-component-anomaly-assigned = Anomalia atribuída ao navio.
anomaly-vessel-component-not-assigned = Este navio não está atribuído a nenhuma anomalia. Tente usá-lo com um scanner.
anomaly-vessel-component-assigned = Este navio está atualmente atribuído a uma anomalia.
anomaly-particles-delta = Partículas Delta
anomaly-particles-epsilon = Partículas Epsilon
anomaly-particles-zeta = Partículas Zeta
anomaly-particles-omega = Partículas Ômega
anomaly-particles-sigma = Partículas Sigma
anomaly-scanner-component-scan-complete = Varredura completa!
anomaly-scanner-ui-title = scanner de anomalias
anomaly-scanner-no-anomaly = Nenhuma anomalia está sendo escaneada no momento.
anomaly-scanner-severity-percentage = Severidade atual: [color=gray]{ $percent }[/color]
anomaly-scanner-severity-percentage-unknown =
    Context key: anomaly-scanner-severity-percentage-unknown
    
    Current severity: [color=red]ERRO[/color]
anomaly-scanner-stability-low =
    Contexto chave: anomaly-scanner-stability-low
    
    Estado atual da anomalia: [color=gold]Decaindo[/color]
anomaly-scanner-stability-medium =
    Contexto: anomalia-scanner-stabilidade-média
    
    Estado atual da anomalia: [color=forestgreen]Estável[/color]
anomaly-scanner-stability-high =
    Contexto chave: anomaly-scanner-stability-high
    
    Estado atual da anomalia: [color=crimson]Crescendo[/color]
anomaly-scanner-stability-unknown =
    Context key: anomaly-scanner-stabilidade-desconhecida
    
    Estado atual da anomalia: [color=red]ERRO[/color]
anomaly-scanner-point-output = [color=gray]{ $point }[/color]
anomaly-scanner-point-output-unknown = [color=red]ERRO[/color]
anomaly-scanner-particle-readout = Análise da Reação de Partículas:
anomaly-scanner-particle-danger = [color=crimson]Tipo de perigo:[/color] { $type }
anomaly-scanner-particle-unstable = [color=plum]Tipo instável:[/color] { $type }
anomaly-scanner-particle-containment = - [color=goldenrod]Tipo de contenção:[/color] { $type }
anomaly-scanner-particle-transformation = - [color=#6b75fa]Tipo de transformação:[/color] { $type }
anomaly-scanner-particle-danger-unknown = - [color=crimson]Tipo de perigo:[/color] [color=red]ERRO[/color]
anomaly-scanner-particle-unstable-unknown = [color=plum]Tipo instável:[/color] [color=red]ERRO[/color]
anomaly-scanner-particle-containment-unknown = - [color=goldenrod]Tipo de contenção:[/color] [color=red]ERRO[/color]
anomaly-scanner-particle-transformation-unknown = - [color=#6b75fa]Tipo de transformação:[/color] [color=red]ERRO[/color]
anomaly-scanner-pulse-timer = Tempo até o próximo pulso: [color=gray]{ $time }[/color]
anomaly-gorilla-core-slot-name = Núcleo de Anomalia
anomaly-gorilla-charge-none = Ele não possui um [bold]núcleo anômalo[/bold] dentro dele.
anomaly-gorilla-charge-limit =
    Ele tem [color={ $count ->
        [3] Verde
        [2] Amarelo
        [1] laranja
        [0] Vermelho
       *[other] roxo
    }]{ $count }{ $count ->
        [one] carregar
       *[other] cargas
    } restante.
anomaly-gorilla-charge-infinite = Ele tem [color=gold]cargas infinitas[/color]. [italic]Por enquanto...[/italic]
anomaly-sync-connected = Anomalia conectada com sucesso
anomaly-sync-disconnected = A conexão com a anomalia foi perdida!
anomaly-sync-no-anomaly = Nenhuma anomalia no alcance.
anomaly-sync-examine-connected = Está [color=darkgreen]anexado[/color] a uma anomalia.
anomaly-sync-examine-not-connected = Ele não está conectado a uma anomalia.
anomaly-sync-connect-verb-text = Anexar anomalia
anomaly-sync-connect-verb-message = Anexe uma anomalia próxima a { THE($machine) }.
anomaly-sync-disconnect-verb-text = Desconectar anomalia
anomaly-sync-disconnect-verb-message = Desconecte a anomalia conectada de { THE($machine) }.
anomaly-generator-ui-title = Gerador de Anomalias
anomaly-generator-fuel-display = Combustível:
anomaly-generator-cooldown = Tempo de recarga: [color=gray]{ $time }[/color]
anomaly-generator-no-cooldown = Cooldown: [color=gray]Completo[/color]
anomaly-generator-yes-fire = Status: [color=forestgreen]Pronto[/color]
anomaly-generator-no-fire =
    Context key: anomaly-generator-no-fire
    
    Status: [color=crimson]Não está pronto[/color]
anomaly-generator-generate = Gerar Anomalia
anomaly-generator-charges =
    { $charges ->
        [one] { $charges } carga
       *[other] { $charges } cargas
    }
anomaly-generator-announcement = Uma anomalia foi gerada!
anomaly-command-pulse = Pulsa uma anomalia alvo
anomaly-command-supercritical = Torna uma anomalia-alvo supercrítica
# Flavor text on the footer
anomaly-generator-flavor-left = A anomalia pode surgir dentro do operador.
anomaly-generator-flavor-right = O gerador de anomalias está prestes a causar uma perturbação no espaço-tempo. Prepare-se para uma experiência única, cheia de mistérios e possíveis consequências imprevisíveis.
anomaly-behavior-unknown = [color=red]ERRO. Não pode ser lido.[/color]
anomaly-behavior-title = Análise de Desvio de Comportamento:
anomaly-behavior-point = [color=gold]Anomalia produz { $mod }% dos pontos[/color]
anomaly-behavior-safe = [color=forestgreen]A anomalia está extremamente estável. Pulsos extremamente raros.[/color]
anomaly-behavior-slow = [color=forestgreen]A frequência das pulsações é muito menos frequente.[/color]
anomaly-behavior-light = [color=forestgreen]A potência de pulsação está significativamente reduzida.[/color]
anomaly-behavior-balanced = Nenhuma desvio de comportamento detectado.
anomaly-behavior-delayed-force = A frequência das pulsações está muito reduzida, mas seu poder está aumentado.
anomaly-behavior-rapid = A frequência da pulsação é muito maior, mas sua intensidade está atenuada.
anomaly-behavior-reflect = Foi detectada uma camada protetora.
anomaly-behavior-nonsensivity = Foi detectada uma reação fraca a partículas.
anomaly-behavior-sensivity = Foi detectada uma reação amplificada a partículas.
anomaly-behavior-invisibility = Foi detectada uma distorção nas ondas de luz.
anomaly-behavior-secret = Interferência detectada. Alguns dados não podem ser lidos
anomaly-behavior-inconstancy = [color=crimson]Impermanência foi detectada. Os tipos de partículas podem mudar ao longo do tempo.[/color]
anomaly-behavior-fast = [color=crimson]A frequência das pulsações está fortemente aumentada.[/color]
anomaly-behavior-strenght = [color=crimson]A potência da pulsação está significativamente aumentada.[/color]
anomaly-behavior-moving = [color=crimson]Instabilidade nas coordenadas foi detectada.[/color]
anomaly-secret-admin = [color=red](ERRO)[/color]
