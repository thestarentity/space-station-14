## Strings for the "grant_connect_bypass" command.

cmd-grant_connect_bypass-desc = Permita temporariamente um usuário a ignorar as verificações regulares de conexão.
cmd-grant_connect_bypass-help =
    Uso: grant_connect_bypass <usuário> [duração em minutos]
    Concede temporariamente a um usuário a capacidade de contornar as restrições de conexão normais.
    O bypass só se aplica a este servidor de jogo e expirará após (por padrão) 1 hora.
    Eles poderão se juntar independentemente da lista de permissão, bunker de pânico ou limite de jogadores.
cmd-grant_connect_bypass-arg-user = Usuário
cmd-grant_connect_bypass-arg-duration = [duração em minutos]
cmd-grant_connect_bypass-invalid-args = Esperado 1 ou 2 argumentos
cmd-grant_connect_bypass-unknown-user = Não foi possível encontrar o usuário '{ $user }'
cmd-grant_connect_bypass-invalid-duration = Duração inválida '{ $duration }'
cmd-grant_connect_bypass-success = Bypass foi adicionado com sucesso para o usuário '{ $user }'
