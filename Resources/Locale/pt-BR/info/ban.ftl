# ban
cmd-ban-desc = Banir alguém
cmd-ban-help = Uso: ban <nome ou ID do usuário> <motivo> [duração em minutos, omitir ou 0 para banimento permanente]
cmd-ban-player = Não foi possível encontrar um jogador com esse nome.
cmd-ban-invalid-minutes = { $minutes } não é uma quantidade válida de minutos!
cmd-ban-invalid-severity = { $severity } não é uma severidade válida!
cmd-ban-invalid-arguments = Quantidade inválida de argumentos
cmd-ban-hint = <name/user ID>
cmd-ban-hint-reason = <reason>
cmd-ban-hint-duration = [duração]
cmd-ban-hint-severity = [gravidade]
cmd-ban-hint-duration-1 = Permanente
cmd-ban-hint-duration-2 = 1 dia
cmd-ban-hint-duration-3 = 3 dias
cmd-ban-hint-duration-4 = 1 semana
cmd-ban-hint-duration-5 = 2 semanas
cmd-ban-hint-duration-6 = 1 mês
# ban panel
cmd-banpanel-desc = Abre o painel de banimento
cmd-banpanel-help = Uso: banpanel [nome ou GUID do usuário]
cmd-banpanel-server = Isso não pode ser usado a partir do console do servidor
cmd-banpanel-player-err = O jogador especificado não pôde ser encontrado
# listbans
cmd-banlist-desc = Lista as proibições ativas de um usuário.
cmd-banlist-help = Uso: banlist <nome ou ID do usuário>
cmd-banlist-empty = Nenhuma banida ativa encontrada para { $user }
cmd-banlist-hint = <name/user ID>
cmd-ban_exemption_update-desc = Defina uma isenção para um tipo de banimento em um jogador.
cmd-ban_exemption_update-help =
    Uso: ban_exemption_update <jogador> <bandeira> [<bandeira> [...]]
    Especifique múltiplas bandeiras para dar a um jogador múltiplas bandeiras de isenção de banimento.
    Para remover todas as isenções, execute este comando e dê "Nenhum" como única bandeira.
cmd-ban_exemption_update-nargs = Faltam pelo menos 2 argumentos
cmd-ban_exemption_update-locate = Não foi possível localizar o jogador '{ $player }'.
cmd-ban_exemption_update-invalid-flag = Bandeira inválida '{ $flag }'.
cmd-ban_exemption_update-success = Atualizadas as bandeiras de isenção de banimento para '{ $player }' ({ $uid }).
cmd-ban_exemption_update-arg-player = Força o espectro a se manifestar.
cmd-ban_exemption_update-arg-flag = /sem_exceção
cmd-ban_exemption_get-desc = Mostrar isenções de banimento para um certo jogador.
cmd-ban_exemption_get-help = Uso: ban_exemption_get <jogador>
cmd-ban_exemption_get-nargs = Esperado exatamente 1 argumento
cmd-ban_exemption_get-none = O usuário não está isento de quaisquer banimentos.
cmd-ban_exemption_get-show = O usuário está isento das seguintes bandeiras de banimento: { $flags }.
cmd-ban_exemption_get-arg-player = Força o espectro a se manifestar.
# Ban panel
ban-panel-title = Painel de Bloqueio
ban-panel-player = Jogador
ban-panel-ip = IP
ban-panel-hwid = HWID
ban-panel-reason = Motivo
ban-panel-last-conn = Usar IP e HWID da última conexão?
ban-panel-submit = Banir
ban-panel-confirm = Tem certeza?
ban-panel-tabs-basic = Informações básicas
ban-panel-tabs-reason = Motivo
ban-panel-tabs-players = Lista de Jogadores
ban-panel-tabs-role = Informações de banimento por cargo
ban-panel-no-data = Você deve fornecer um usuário, IP ou HWID para banir.
ban-panel-invalid-ip = O endereço IP não pôde ser analisado. Por favor, tente novamente.
ban-panel-select = Selecione o tipo
ban-panel-server = Banido do servidor
ban-panel-role = Banimento de papel de cargo
ban-panel-minutes = Minutos
ban-panel-hours = Horas
ban-panel-days = Dias
ban-panel-weeks = Semanas
ban-panel-months = Meses
ban-panel-years = Anos
ban-panel-permanent = Permanente
ban-panel-ip-hwid-tooltip = Deixe vazio e marque a caixa abaixo para usar os detalhes da última conexão
ban-panel-severity = Gravidade:
ban-panel-erase = Apagar mensagens de chat e jogador da rodada
ban-panel-expiry-error = O tempo de expiração deve ser maior que zero.
# Ban string
server-ban-string = { $admin } criou um banimento do servidor de severidade { $severity } que expira { $expires } para [{ $name }, { $ip }, { $hwid }], com motivo: { $reason }
server-ban-string-no-pii = { $admin } criou um banimento do servidor de severidade { $severity } que expira { $expires } para { $name } com a razão: { $reason }
server-ban-string-never = nunca
# Kick on ban
ban-kick-reason = Você foi banido
