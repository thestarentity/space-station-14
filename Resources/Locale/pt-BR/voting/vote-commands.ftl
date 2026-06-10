### Voting system related console commands

## 'createvote' command

cmd-createvote-desc = Cria um voto
cmd-createvote-help = Uso: createvote <'restart'|'preset'|'map'>
cmd-createvote-cannot-call-vote-now = Você não pode chamar uma votação agora!
cmd-createvote-invalid-vote-type = Tipo de voto inválido
cmd-createvote-arg-vote-type = <tipo de voto>

## 'customvote' command

cmd-customvote-desc = Cria um voto personalizado
cmd-customvote-help = Uso: customvote <title> <option1> <option2> [option3...]
cmd-customvote-on-finished-tie = A votação '{ $title }' terminou: empate entre { $ties }!
cmd-customvote-on-finished-win = O voto '{ $title }' terminou: { $winner } vence!
cmd-customvote-arg-title = <título>
cmd-customvote-arg-option-n = <opção{ $n }>

## 'vote' command

cmd-vote-desc = Vota em uma votação ativa
cmd-vote-help = vote <voteId> <opção>
cmd-vote-cannot-call-vote-now = Você não pode chamar uma votação agora!
cmd-vote-on-execute-error-must-be-player = Você deve ser um jogador
cmd-vote-on-execute-error-invalid-vote-id = ID de voto inválido
cmd-vote-on-execute-error-invalid-vote-options = Opções de voto inválidas
cmd-vote-on-execute-error-invalid-vote = Voto inválido
cmd-vote-on-execute-error-invalid-option = Opção inválida

## 'listvotes' command

cmd-listvotes-desc = Lista de votos ativos atualmente
cmd-listvotes-help = Uso: listvotes

## 'cancelvote' command

cmd-cancelvote-desc = Cancela um voto ativo
cmd-cancelvote-help =
    Uso: cancelvote <id>
    Você pode obter o ID da lista de votos usando o comando listvotes.
cmd-cancelvote-error-invalid-vote-id = ID de voto inválido
cmd-cancelvote-error-missing-vote-id = ID ausente
cmd-cancelvote-arg-id = <id>
