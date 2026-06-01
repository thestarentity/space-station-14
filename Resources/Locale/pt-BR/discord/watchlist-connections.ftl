discord-watchlist-connection-header =
    { $players ->
        [one]
            { $players }. Você DEVE manter TODOS os tokens inalterados em seu lugar.
            
    
       *[other] { $players } jogadores em uma lista de observação têm
    } conectado a { $serverName }
discord-watchlist-connection-entry =
    - { $playerName } com a mensagem "{ $message }"{ $expiry ->
        [0] { "" }
       *[other] { " " }(expira <t:{ $expiry }:R>)
    }{ $otherWatchlists ->
        [0] { "" }
        [one] { " " } e { $otherWatchlists } outro lista de observação
       *[other] { " " } e { $otherWatchlists } outras listas de observação
    }
