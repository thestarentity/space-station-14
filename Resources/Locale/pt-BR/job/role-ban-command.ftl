### Localization for role ban command

cmd-roleban-desc = Impede um jogador de assumir um cargo
cmd-roleban-help = Usage: roleban <nome ou ID do usuário> <cargo> <motivo> [duração em minutos, omitir ou 0 para banimento permanente]

## Completion result hints

cmd-roleban-hint-1 = <nome ou ID do usuário>
cmd-roleban-hint-2 = <cargo>
cmd-roleban-hint-3 = <motivo>
cmd-roleban-hint-4 = [duração em minutos, omita ou 0 para banimento permanente]
cmd-roleban-hint-5 = [gravidade]
cmd-roleban-hint-duration-1 = Permanente
cmd-roleban-hint-duration-2 = 1 dia
cmd-roleban-hint-duration-3 = 3 dias
cmd-roleban-hint-duration-4 = 1 semana
cmd-roleban-hint-duration-5 = 2 semanas
cmd-roleban-hint-duration-6 = 1 mês

### Localization for role unban command

cmd-roleunban-desc = Perdoa a proibição de cargo de um jogador
cmd-roleunban-help = Uso: roleunban <id do banimento de cargo>
cmd-roleunban-unable-to-parse-id =
    Não foi possível analisar { $id } como um ID de banimento inteiro.
    { $help }

## Completion result hints

cmd-roleunban-hint-1 = <id do banimento de cargo>

### Localization for roleban list command

cmd-rolebanlist-desc = Lista as proibições de cargo do usuário
cmd-rolebanlist-help = Uso: <nome ou ID do usuário> [inclua desbancados]

## Completion result hints

cmd-rolebanlist-hint-1 = <nome ou ID do usuário>
cmd-rolebanlist-hint-2 = [incluir desbancados]
cmd-roleban-minutes-parse = { $time } não é uma quantidade válida de minutos.\n{ $help }
cmd-roleban-severity-parse = ${ severity } não é uma severidade válida\n{ $help }.
cmd-roleban-arg-count = Quantidade inválida de argumentos.
cmd-roleban-job-parse = O cargo { $job } não existe.
cmd-roleban-name-parse = Não foi possível encontrar um jogador com esse nome.
cmd-roleban-success = O cargo proibiu { $target } de { $role } com a razão { $reason } { $length }.
cmd-roleban-inf = permanentemente
cmd-roleban-until = até { $expires }
# Department bans
cmd-departmentban-desc = Impede um jogador de assumir os cargos que compõem um departamento
cmd-departmentban-help = Uso: departmentban <nome ou ID do usuário> <departamento> <motivo> [duração em minutos, omita ou 0 para banimento permanente]
