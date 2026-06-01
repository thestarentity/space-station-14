markings-search = Pesquisar
-markings-selection =
    { $selectable ->
        [0] Você não tem mais marcas disponíveis.
        [one] Você pode selecionar uma marcação adicional.
       *[other] Você pode selecionar { $selectable } mais marcas.
    }
markings-limits = { $required ->
    [true] { $count ->
        [-1] Selecione pelo menos uma marca.
        [0] Você não pode selecionar nenhuma marca, mas de alguma forma precisa? Isso é um bug.
        [one] Selecione uma marca.
       *[other] Selecione pelo menos uma marca e até { $count } marcas. { -markings-selection(selectable: $selectable) }
    }
   *[false] { $count ->
        [-1] Selecione qualquer número de marcas.
        [0] Você não pode selecionar nenhuma marca.
        [one] Selecione até uma marca.
       *[other] Selecione até { $count } marcas. { -markings-selection(selectable: $selectable) }
    }
}
markings-reorder = Reordenar marcas
humanoid-marking-modifier-respect-limits = Respeite os limites
humanoid-marking-modifier-respect-group-sex = Restrições de grupo de respeito & sexo
humanoid-marking-modifier-base-layers = Camadas básicas
humanoid-marking-modifier-enable = Ativar
humanoid-marking-modifier-prototype-id = ID do protótipo

# Categories

markings-organ-Torso = Tórax
markings-organ-Head = Cabeça carbonizada
markings-organ-ArmLeft = Braço Esquerdo
markings-organ-ArmRight = Braço Direito
markings-organ-HandRight = Mão Direita
markings-organ-HandLeft = Mão Esquerda
markings-organ-LegLeft = Perna Esquerda
markings-organ-LegRight = Perna Direita
markings-organ-FootLeft = Pé Esquerdo
markings-organ-FootRight = Pé Direito
markings-organ-Eyes = Olhos
markings-layer-Special = Especial
markings-layer-Tail = Cauda
markings-layer-Tail-Moth = Asas
markings-layer-Hair = Cabelo
markings-layer-FacialHair = Cabelo Facial
markings-layer-UndergarmentTop = Camiseta interior
markings-layer-UndergarmentBottom = Calções
markings-layer-Chest = Cofre
markings-layer-Head = Cabeça carbonizada
markings-layer-Snout = Snout
markings-layer-SnoutCover = Snout (Cobertura)
markings-layer-HeadSide = Cabeça (Lado)
markings-layer-HeadTop = Cabeça (Topo)
markings-layer-Eyes = Olhos
markings-layer-RArm = Braço Direito
markings-layer-LArm = Braço Esquerdo
markings-layer-RHand = Mão Direita
markings-layer-LHand = Mão Esquerda
markings-layer-RLeg = Perna Direita
markings-layer-LLeg = Perna Esquerda
markings-layer-RFoot = Pé Direito
markings-layer-LFoot = Pé Esquerdo
markings-layer-Overlay = Sobrepainel
markings-layer-TailOverlay = Sobrepainel
