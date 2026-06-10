# Displayed as initiator of vote when no user creates the vote
ui-vote-initiator-server = O servidor

## Default.Votes

ui-vote-restart-title = Reiniciar rodada
ui-vote-restart-succeeded = Voto de reinício bem-sucedido.
ui-vote-restart-failed = Voto de reinício falhou (precisamos de { TOSTRING($ratio, "P0") }).
ui-vote-restart-fail-not-enough-ghost-players = Voto de reinício falhou: É necessário um mínimo de { $ghostPlayerRequirement }% de jogadores fantasma para iniciar um voto de reinício. Atualmente, não há jogadores fantasma suficientes.
ui-vote-restart-yes = Sim
ui-vote-restart-no = Não
ui-vote-restart-abstain = Abster-se
ui-vote-gamemode-title = Próximo modo de jogo
ui-vote-gamemode-tie = Empate na votação do modo de jogo! Escolhendo... { $picked }
ui-vote-gamemode-win = { $winner } venceu a votação do modo de jogo!
ui-vote-map-title = Próximo mapa
ui-vote-map-tie = Empate na votação do mapa! Escolhendo... { $picked }
ui-vote-map-win = { $winner } venceu a votação de mapas!
ui-vote-map-notlobby = Votar por mapas só é válido na sala de espera antes do início da rodada!
ui-vote-map-notlobby-time = Votação por mapas só é válida na sala de espera pré-partida com { $time } restantes!
ui-vote-map-invalid = { $winner } se tornou inválido após a votação do mapa! Não será selecionado!
# Votekick votes
ui-vote-votekick-unknown-initiator = Um jogador
ui-vote-votekick-unknown-target = Jogador Desconhecido
ui-vote-votekick-title = { $initiator } chamou um votekick para o usuário: { $targetEntity }. Motivo: { $reason }
ui-vote-votekick-yes = Sim
ui-vote-votekick-no = Não
ui-vote-votekick-abstain = Abster-se
ui-vote-votekick-success = O votekick para { $target } foi bem-sucedido. Motivo do votekick: { $reason }
ui-vote-votekick-failure = A votekick para { $target } falhou. Motivo da votekick: { $reason }
ui-vote-votekick-not-enough-eligible = Não há votantes elegíveis suficientes online para iniciar um votekick: { $voters }/{ $requirement }
ui-vote-votekick-server-cancelled = O votekick para { $target } foi cancelado pelo servidor.
