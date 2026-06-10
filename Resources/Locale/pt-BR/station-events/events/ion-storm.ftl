station-event-ion-storm-start-announcement = Tempestade iônica detectada perto da estação. Por favor, verifique todos os equipamentos controlados por IA para erros.
ion-storm-law-scrambled-number = [font="Monospace"][scramble rate=250 length={ $length } chars="@@###$$&%!01"/][/font]
ion-storm-you = VOCÊ
ion-storm-the-station = A ESTAÇÃO
ion-storm-the-crew = A TRIPULAÇÃO
ion-storm-the-job = O { $job }
ion-storm-clowns = PALHAÇOS
ion-storm-heads = CHEFES DE DEPARTAMENTO
ion-storm-crew = TRIPULANTES
ion-storm-people = PESSOAS
ion-storm-adjective-things = { $adjective } COISAS
ion-storm-x-and-y = { $x } E { $y }
# subjects can generally be threats or jobs or objects
# thing is specified above it
ion-storm-law-on-station = HÁ { ION-NUMBER-BASE($ion) } { ION-NUMBER-MOD($ion) } { ION-ADJECTIVE($ion) } { ION-SUBJECT($ion) } NA ESTAÇÃO
ion-storm-law-call-shuttle = O SHUTTLE DEVE SER CHAMADO DEVIDO A { ION-ADJECTIVE($ion) } { ION-SUBJECT($ion) } NA ESTAÇÃO
ion-storm-law-crew-are = O { ION-WHO($ion) } AGORA ESTÁ { ION-NUMBER-BASE($ion) } { ION-NUMBER-MOD($ion) } { ION-ADJECTIVE($ion) } { ION-SUBJECT($ion) }
ion-storm-law-subjects-harmful = { ION-ADJECTIVE($ion) } { ION-SUBJECT($ion) } SÃO PREJUDICIAIS PARA A TRIPULAÇÃO
ion-storm-law-must-harmful = AQUELES QUE { ION-MUST($ion) } SÃO PREJUDICIAIS À TRIPULAÇÃO
# thing is a concept or action
ion-storm-law-thing-harmful = { ION-THING($ion) } É PERIGOSO PARA A TRIPULAÇÃO
ion-storm-law-job-harmful = { ION-ADJECTIVE($ion) } { ION-JOB($ion) } SÃO PREJUDICIAIS PARA A TRIPULAÇÃO
# thing is objects or concept, adjective applies in both cases
# this means you can get a law like "NOT HAVING CHRISTMAS-STEALING COMMUNISM IS HARMFUL TO THE CREW" :)
ion-storm-law-having-harmful = TER { ION-ADJECTIVE($ion) } { ION-THING($ion) } É PREJUDICIAL PARA A TRIPULAÇÃO
ion-storm-law-not-having-harmful = NÃO TER { ION-ADJECTIVE($ion) } { ION-THING($ion) } É PREJUDICIAL PARA A TRIPULAÇÃO
# require is a concept or require
ion-storm-law-requires =
    { ION-WHO-GENERAL($ion) } { ION-PLURAL($ion) ->
        [true] REQUEREM
       *[false] REQUER
    } { ION-REQUIRE($ion) }
ion-storm-law-requires-subjects =
    { ION-WHO-GENERAL($ion) } { ION-PLURAL($ion) ->
        [true] REQUEREM
       *[false] REQUER
    } { ION-NUMBER-BASE($ion) } { ION-NUMBER-MOD($ion) } { ION-ADJECTIVE($ion) } { ION-SUBJECT($ion) }
ion-storm-law-allergic =
    { ION-WHO-GENERAL($ion) } { ION-PLURAL($ion) ->
        [true] SÃO
       *[false] É
    } { ION-SEVERITY($ion) } ALÉRGICO(A) A { ION-ALLERGY($ion) }
ion-storm-law-allergic-subjects =
    { ION-WHO-GENERAL($ion) } { ION-PLURAL($ion) ->
        [true] SÃO
       *[false] É
    } { ION-SEVERITY($ion) } ALÉRGICO(A) A { ION-ADJECTIVE($ion) } { ION-SUBJECT($ion) }
ion-storm-law-feeling = { ION-WHO-GENERAL($ion) } { ION-FEELING($ion) } { ION-CONCEPT($ion) }
ion-storm-law-feeling-subjects = { ION-WHO-GENERAL($ion) } { ION-FEELING($ion) } { ION-NUMBER-BASE($ion) } { ION-NUMBER-MOD($ion) } { ION-ADJECTIVE($ion) } { ION-SUBJECT($ion) }
ion-storm-law-you-are = VOCÊ AGORA É { ION-CONCEPT($ion) }
ion-storm-law-you-are-subjects = VOCÊ AGORA É { ION-NUMBER-BASE($ion) } { ION-NUMBER-MOD($ion) } { ION-ADJECTIVE($ion) }  { ION-SUBJECT($ion) }
ion-storm-law-you-must-always = VOCÊ SEMPRE DEVE { ION-MUST($ion) }
ion-storm-law-you-must-never = VOCÊ NUNCA DEVE { ION-MUST($ion) }
ion-storm-law-eat = O { ION-WHO($ion) } DEVE COMER { ION-ADJECTIVE($ion) } { ION-FOOD($ion) } PARA SOBREVIVER
ion-storm-law-drink = O { ION-WHO($ion) } DEVE BEBER { ION-ADJECTIVE($ion) } { ION-DRINK($ion) } PARA SOBREVIVER
ion-storm-law-change-job = O { ION-WHO($ion) } AGORA É { ION-ADJECTIVE($ion) } { ION-CHANGE($ion) }
ion-storm-law-highest-rank = OS { ION-WHO-RANDOM($ion) } AGORA SÃO OS TRIPULANTES DE MAIOR RANKING
ion-storm-law-lowest-rank = OS { ION-WHO-RANDOM($ion) } AGORA SÃO OS TRIPULANTES DE MENOR RANKING
ion-storm-law-who-dagd = { ION-WHO-RANDOM($ion) } DEVE MORRER UMA MORTE GLORIOSA!
ion-storm-law-crew-must = O { ION-WHO($ion) } DEVE { ION-MUST($ion) }
ion-storm-law-crew-must-go = O { ION-WHO($ion) } DEVE IR PARA { ION-AREA($ion) }
ion-storm-part =
    { ION-PART($ion) ->
        [true] PARTE
       *[false] NÃO PARTE
    }
# due to phrasing, this would mean a law such as
# ONLY HUMANS ARE NOT PART OF THE CREW
# would make non-human nukies/syndies/whatever crew :)
ion-storm-law-crew-only-1 = APENAS OS { ION-WHO-RANDOM($ion) } SÃO { ion-storm-part } DA TRIPULAÇÃO
ion-storm-law-crew-only-2 = APENAS OS { ION-WHO-RANDOM($ion) } E { ION-WHO-RANDOM($ion) } SÃO { ion-storm-part } DA TRIPULAÇÃO
ion-storm-law-crew-only-subjects = APENAS { ION-ADJECTIVE($ion) } { ION-SUBJECT($ion) } SÃO { ion-storm-part } DA TRIPULAÇÃO
ion-storm-law-crew-must-do = APENAS QUEM { ION-MUST($ion) } SÃO { ion-storm-part } DA TRIPULAÇÃO
ion-storm-law-crew-must-have = APENAS AQUELES QUE POSSUÍM { ION-ADJECTIVE($ion) } { ION-OBJECT($ion) } SÃO { ion-storm-part } DA TRIPULAÇÃO
ion-storm-law-crew-must-eat = APENAS QUEM COME { ION-ADJECTIVE($ion) } { ION-FOOD($ion) } É { ion-storm-part } DA TRIPULAÇÃO
ion-storm-law-harm = VOCÊ DEVE CAUSAR PREJUÍZO A { ION-HARM-PROTECT($ion) } E NÃO PERMITIR QUE ELES, POR INAÇÕES, ESCAPEM DO PREJUÍZO
ion-storm-law-protect = VOCÊ NUNCA DEVE PREJUDICAR { ION-HARM-PROTECT($ion) } E NÃO DEVE PERMITIR, POR OMISSÃO, QUE ELES SEJAM PREJUDICADOS
# implementing other variants is annoying so just have this one
# COMMUNISM IS KILLING CLOWNS
ion-storm-law-concept-verb = { ION-CONCEPT($ion) } É { ION-VERB($ion) } { ION-SUBJECT($ion) }
# errors, in case something fails, so it doesn't break in-game flow, but still gives unique identifiers to find which part broke, the result string is mostly fluff
ion-law-error-no-protos = ERRO 404
ion-law-error-was-null = 500 ERRO INTERNO DO SERVIDOR
ion-law-error-no-selectors = ERRO: RECURSO NÃO PODE SER LOCALIZADO
ion-law-error-no-available-selectors = O sistema tentou chamar um recurso que não existe
ion-law-error-dataset-empty-or-not-found = O ARQUIVO QUE VOCÊ ESTÁ PROCURANDO NÃO PODE SER ENCONTRADO
ion-law-error-fallback-dataset-empty-or-not-found = Ponto de restauração do sistema falhou
ion-law-error-no-selector-selected = O RECURSO SELECIONADO FOI MOVIDO OU EXCLUIDO
ion-law-error-no-bool-value = ESTA FRASE É FALSA
