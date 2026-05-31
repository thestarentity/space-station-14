### Locale for wielding items; i.e. two-handing them

wieldable-verb-text-wield = Usar
wieldable-verb-text-unwield = Desarmar
wieldable-component-successful-wield = Você segura { THE($item) }.
wieldable-component-failed-wield = Você desembarra { THE($item) }.
wieldable-component-successful-wield-other = { CAPITALIZE(THE($user)) } segura { THE($item) }.
wieldable-component-failed-wield-other = { CAPITALIZE(THE($user)) } deixa de segurar { THE($item) }.
wieldable-component-blocked-wield = { CAPITALIZE(THE($blocker)) } bloqueia você de usar { THE($item) }.
wieldable-component-no-hands = Você não tem mãos suficientes!
wieldable-component-not-enough-free-hands =
    { $number ->
        [one] Você precisa de uma mão livre para usar { THE($item) }.
       *[other] Você precisa de { $number } mãos livres para usar { THE($item) }.
    }
wieldable-component-not-in-hands = { CAPITALIZE(THE($item)) } não está em suas mãos!
wieldable-component-requires = { CAPITALIZE(THE($item)) } deve ser empunhado!
gunwieldbonus-component-examine = Esta arma tem precisão aprimorada quando empunhada.
gunrequireswield-component-examine = Essa arma só pode ser disparada quando segurada.
