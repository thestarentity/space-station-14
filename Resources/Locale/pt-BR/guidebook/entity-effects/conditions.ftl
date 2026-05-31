entity-condition-guidebook-total-damage =
    { $max ->
        [2147483648] tem pelo menos { NATURALFIXED($min, 2) } de dano total
       *[other]
            { $min ->
                [0] ele tem no máximo { NATURALFIXED($max, 2) } de dano total
               *[other] ele tem entre { NATURALFIXED($min, 2) } e { NATURALFIXED($max, 2) } de dano total
            }
    }
entity-condition-guidebook-type-damage =
    { $max ->
        [2147483648] ele tem pelo menos { NATURALFIXED($min, 2) } de { $type } de dano
       *[other]
            { $min ->
                [0] ele tem no máximo { NATURALFIXED($max, 2) } de { $type } de dano
               *[other] ele tem entre { NATURALFIXED($min, 2) } e { NATURALFIXED($max, 2) } de dano { $type }
            }
    }
entity-condition-guidebook-group-damage =
    { $max ->
        [2147483648] ele tem pelo menos { NATURALFIXED($min, 2) } de dano { $type }.
       *[other]
            { $min ->
                [0] ele tem no máximo { NATURALFIXED($max, 2) } de { $type } de dano.
               *[other] ele tem entre { NATURALFIXED($min, 2) } e { NATURALFIXED($max, 2) } de dano { $type }
            }
    }
entity-condition-guidebook-total-hunger =
    { $max ->
        [2147483648] o alvo tem pelo menos { NATURALFIXED($min, 2) } fome total
       *[other]
            { $min ->
                [0] o alvo tem no máximo { NATURALFIXED($max, 2) } fome total
               *[other] o alvo tem entre { NATURALFIXED($min, 2) } e { NATURALFIXED($max, 2) } fome total
            }
    }
entity-condition-guidebook-reagent-threshold =
    { $max ->
        [2147483648] tem pelo menos { NATURALFIXED($min, 2) }u de { $reagent }
       *[other]
            { $min ->
                [0] tem no máximo { NATURALFIXED($max, 2) }u de { $reagent }
               *[other] tem entre { NATURALFIXED($min, 2) }u e { NATURALFIXED($max, 2) }u de { $reagent }
            }
    }
entity-condition-guidebook-mob-state-condition = o mob é { $state }
entity-condition-guidebook-job-condition = o cargo do alvo é { $job }
entity-condition-guidebook-solution-temperature =
    a temperatura da solução é{ $max ->
        [2147483648] pelo menos { NATURALFIXED($min, 2) }k
       *[other]
            { $min ->
                [0] no máximo { NATURALFIXED($max, 2) }k
               *[other] entre { NATURALFIXED($min, 2) }k e { NATURALFIXED($max, 2) }k
            }
    }
entity-condition-guidebook-body-temperature =
    a temperatura do corpo é{ $max ->
        [2147483648] pelo menos { NATURALFIXED($min, 2) }k
       *[other]
            { $min ->
                [0] no máximo { NATURALFIXED($max, 2) }k
               *[other] entre { NATURALFIXED($min, 2) }k e { NATURALFIXED($max, 2) }k
            }
    }
entity-condition-guidebook-organ-type =
    o órgão metabolizador{ $shouldhave ->
        [true] sim
       *[false] não é
    }{ INDEFINITE($name) } { $name } órgão
entity-condition-guidebook-has-tag =
    o alvo{ $invert ->
        [true] não tem
       *[false] tem
    }a tag { $tag }
entity-condition-guidebook-this-reagent = este reagente
entity-condition-guidebook-breathing =
    o metabolizador é{ $isBreathing ->
        [true] respirando normalmente
       *[false] sufocando
    }
entity-condition-guidebook-internals =
    o metabolizador é { $usingInternals ->
        [true] Usando internos
       *[false] respirando ar atmosférico
    }
