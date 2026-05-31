-entity-heater-setting-name =
    { $setting ->
        [off] desligado
        [low] baixo
        [medium] médio
        [high] alto
       *[other] Fonte desconhecida
    }
entity-heater-examined =
    Está definido para{ $setting ->
        [off] { -entity-heater-setting-name(setting: "off") }
        [low] { -entity-heater-setting-name(setting: "low") }
        [medium] [color=orange]{ -entity-heater-setting-name(setting: "medium") }[/color]
        [high] [color=vermelho]{ -entity-heater-setting-name(setting: "high") }[/color]
       *[other] { -entity-heater-setting-name(setting: "other") }
    }A bolta parece estar solta. Você pode tentar apertá-la com uma ferramenta de manutenção.
