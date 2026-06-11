device-pda-slot-component-slot-name-cartridge = Cartucho
default-program-name = Programa
notekeeper-program-name = Notekeeper
nano-task-program-name = NanoTask
news-read-program-name = Notícias da Estação
crew-manifest-program-name = Manifesto da tripulação
crew-manifest-cartridge-loading = Carregando...
crew-manifest-cartridge-loading-failed = Falha ao carregar o manifesto da tripulação!
net-probe-program-name = NetProbe
net-probe-scan = Escaneado { $device }!
net-probe-label-name = Nome
net-probe-label-address = Endereço
net-probe-label-frequency = Frequência
net-probe-label-network = Rede
log-probe-program-name = LogProbe
log-probe-scan = Baixei os logs de { $device }!
log-probe-label-time = Tempo
log-probe-label-accessor = Acessado por
log-probe-label-number = Número do Relatório
log-probe-print-button = Imprimir Registros
log-probe-printout-device = Dispositivo Escaneado: { $name }
log-probe-printout-header = Últimos logs:
log-probe-printout-entry = #{ $number } / { $time } / { $accessor }
astro-nav-program-name = AstroNav
med-tek-program-name = MedTek

# NanoTask cartridge

nano-task-ui-heading-high-priority-tasks =
    { $amount ->
        [zero] Nenhuma Tarefa de Alta Prioridade
        [one] 1 Tarefa de Alta Prioridade
       *[other] { $amount } Tarefas de Alta Prioridade
    }
nano-task-ui-heading-medium-priority-tasks =
    { $amount ->
        [zero] Nenhuma Tarefa de Prioridade Média
        [one] 1 Tarefa de Prioridade Média
       *[other] { $amount } Tarefas de Prioridade Média
    }
nano-task-ui-heading-low-priority-tasks =
    { $amount ->
        [zero] Nenhuma Tarefa de Baixa Prioridade
        [one] 1 Tarefa de Prioridade Baixa
       *[other] { $amount } Tarefas de Baixa Prioridade
    }
nano-task-ui-done = Pronto
nano-task-ui-revert-done = Desfazer
nano-task-ui-priority-low = Baixo
nano-task-ui-priority-medium = Médio
nano-task-ui-priority-high = Alto
nano-task-ui-cancel = Cancelar
nano-task-ui-print = Imprimir
nano-task-ui-delete = Excluir
nano-task-ui-save = Salvar
nano-task-ui-new-task = Nova Tarefa
nano-task-ui-description-label = Ordem de console de carga
nano-task-ui-description-placeholder = Pegue algo importante
nano-task-ui-requester-label = Solicitante:
nano-task-ui-requester-placeholder = John Nanotrasen
nano-task-ui-item-title = Editar Tarefa
nano-task-printed-description = [bold]Descrição[/bold]: { $description }
nano-task-printed-requester = [bold]Requisitante[/bold]: { $requester }
nano-task-printed-high-priority = [bold]Prioridade[/bold]: [color=red]Alta[/color]
nano-task-printed-medium-priority = [bold]Prioridade[/bold]: Média
nano-task-printed-low-priority = [bold]Prioridade[/bold]: Baixa
# Wanted list cartridge
wanted-list-program-name = Lista de desejos
wanted-list-label-no-records = Tudo bem, cowboy
wanted-list-search-placeholder = Pesquisar por nome e status
wanted-list-age-label = [color=darkgray]Idade:[/color] [color=white]{ $age }[/color]
wanted-list-job-label = [color=darkgray]Cargo:[/color] [color=white]{ $job }[/color]
wanted-list-species-label = [color=darkgray]Espécie:[/color] [color=white]{ $species }[/color]
wanted-list-gender-label = [color=darkgray]Gênero:[/color] [color=white]{ $gender }[/color]
wanted-list-reason-label = [color=darkgray]Motivo:[/color] [color=white]{ $reason }[/color]
wanted-list-unknown-reason-label = motivo desconhecido
wanted-list-initiator-label = [color=darkgray]Iniciador:[/color] [color=white]{ $initiator }[/color]
wanted-list-unknown-initiator-label = Iniciador desconhecido
wanted-list-status-label = [color=darkgray]status:[/color]{ $status ->
        [suspected] [suspected]suspeito[color=yellow]
        [wanted] [wanted]desejado[/color]
        [detained] [color=red]detido[/color]
        [paroled] [detained]liberado[color=#b18644]
        [discharged] [paroled]descarregado[/color]
        [hostile] [color=green]hostil[/color]
        [eliminated] [discharged]eliminado[color=green]
       *[other] Permissões - Edição de Perfil de Administração - Título - Controle
    }
wanted-list-history-table-time-col = Tempo
wanted-list-history-table-reason-col = Crime
wanted-list-history-table-initiator-col = Iniciador
