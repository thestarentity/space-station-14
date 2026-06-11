parse-minutes-fail = Não foi possível analisar '{ $minutes }' como minutos
parse-session-fail = Não foi possível encontrar a sessão para '{ $username }'

## Role Timer Commands

# - playtime_addoverall
cmd-playtime_addoverall-desc = Adiciona os minutos especificados ao tempo total de jogo de um jogador
cmd-playtime_addoverall-help = Uso: { $command } <nome do usuário> <minutos>
cmd-playtime_addoverall-succeed = Aumentado o tempo total para { $username } para { TOSTRING($time, "dddd\\:hh\\:mm") }
cmd-playtime_addoverall-arg-user = <user name>
cmd-playtime_addoverall-arg-minutes = <minutes>
cmd-playtime_addoverall-error-args = Foram fornecidos argumentos incorretos. É esperado exatamente dois argumentos.
# - playtime_addrole
cmd-playtime_addrole-desc = Adiciona o número especificado de minutos ao tempo de jogo no cargo de um jogador
cmd-playtime_addrole-help = Uso: { $command } <nome do usuário> <cargo> <minutos>
cmd-playtime_addrole-succeed = Aumentado o tempo de jogo no cargo para { $username } / \'{ $role }\' para { TOSTRING($time, "dddd\\:hh\\:mm") }
cmd-playtime_addrole-arg-user = <user name>
cmd-playtime_addrole-arg-role = <role>
cmd-playtime_addrole-arg-minutes = <minutes>
cmd-playtime_addrole-error-args = Você precisa fornecer exatamente três argumentos.
# - playtime_getoverall
cmd-playtime_getoverall-desc = Obtém os minutos especificados para o tempo total de jogo de um jogador
cmd-playtime_getoverall-help = Mostra o tempo total jogado por { $command }.
cmd-playtime_getoverall-success = O tempo total para { $username } é { TOSTRING($time, "dddd\\:hh\\:mm") }.
cmd-playtime_getoverall-arg-user = <user name>
cmd-playtime_getoverall-error-args = Foi fornecido um argumento incorreto. Por favor, forneça o nome de um tripulante.
# - GetRoleTimer
cmd-playtime_getrole-desc = Obtém todos ou um temporizador de cargo de um jogador
cmd-playtime_getrole-help = Usage: { $command } <nome do usuário> [cargo]
cmd-playtime_getrole-no = Nenhum temporizador de cargo encontrado
cmd-playtime_getrole-role = Cargo: { $role }, Tempo de Jogo: { $time }
cmd-playtime_getrole-overall = O tempo de jogo geral é { $time }
cmd-playtime_getrole-succeed = O tempo de jogo para { $username } é: { TOSTRING($time, "dddd\\:hh\\:mm") }.
cmd-playtime_getrole-arg-user = <user name>
cmd-playtime_getrole-arg-role = <role|'Overall'>
cmd-playtime_getrole-error-args = Esperado exatamente um ou dois argumentos
# - playtime_save
cmd-playtime_save-desc = Salva os tempos de jogo do jogador no DB
cmd-playtime_save-help = Mostra o tempo total jogado por { $command }.
cmd-playtime_save-succeed = Salvo tempo de jogo para { $username }
cmd-playtime_save-arg-user = <user name>
cmd-playtime_save-error-args = Foi fornecido um argumento incorreto. Por favor, forneça o nome de um tripulante.

## 'playtime_flush' command'

cmd-playtime_flush-desc = Esvazie os rastreadores ativos para o armazenamento de rastreamento de tempo de jogo.
cmd-playtime_flush-help =
    Uso: { $command } [nome do usuário]
    Isso causa um flush apenas na armazenamento interno, não é gravado no DB imediatamente.
    Se um usuário for fornecido, apenas esse usuário será flushado.
cmd-playtime_flush-error-args = Esperado zero ou um argumento
cmd-playtime_flush-arg-user = [user name]
