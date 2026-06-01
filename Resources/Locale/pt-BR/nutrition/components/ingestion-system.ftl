### Interaction Messages


# System


## When trying to ingest without the required utensil... but you gotta hold it

ingestion-you-need-to-hold-utensil = Você precisa estar segurando { INDEFINITE($utensil) } { $utensil } para comer isso!
ingestion-try-use-is-empty = { CAPITALIZE(THE($entity)) } está vazio!
ingestion-try-use-wrong-utensil = Você não pode { $verb } { THE($food) } com { INDEFINITE($utensil) } { $utensil }.
ingestion-remove-mask = Você precisa tirar o { $entity } primeiro.

## Failed Ingestion

ingestion-you-cannot-ingest-any-more = Você não pode { $verb } mais!
ingestion-other-cannot-ingest-any-more = { CAPITALIZE(SUBJECT($target)) } não pode { $verb } mais!
ingestion-cant-digest = Você não pode digerir { THE($entity) }!
ingestion-cant-digest-other = { CAPITALIZE(SUBJECT($target)) } não consegue digerir { THE($entity) }!

## Action Verbs, not to be confused with Verbs

ingestion-verb-food = Comer
ingestion-verb-drink = Beber

# Edible Component

-edible-satiated =
    { $satiated ->
        [true] { " " }Você não tem a sensação de que poderia { $verb } mais.
       *[false] { "" }
    }
edible-nom = Nom. { $flavors }{ -edible-satiated(satiated: $satiated, verb: "eat") }
edible-nom-other = Nom.
edible-slurp = Slurp. { $flavors }{ -edible-satiated(satiated: $satiated, verb: "drink") }
edible-slurp-other = Sucção.
edible-swallow = Você engoliu { THE($food) }.{ -edible-satiated(satiated: $satiated, verb: "swallow") }
edible-gulp = Gulp. { $flavors }
edible-gulp-other = Engolir.
edible-has-used-storage = Você não pode { $verb } { THE($food) } com um item armazenado dentro.

## Nouns

edible-noun-edible = comestível
edible-noun-food = comida
edible-noun-drink = bebida
edible-noun-pill = pílula

## Verbs

edible-verb-edible = ingerir
edible-verb-food = comer
edible-verb-drink = bebida
edible-verb-pill = engolir

## Force feeding

edible-force-feed = { CAPITALIZE(THE($user)) } está tentando fazer você { $verb } algo!
edible-force-feed-success = { CAPITALIZE(THE($user)) } te forçou a { $verb } algo! { $flavors }{ -edible-satiated(satiated: $satiated, verb: $verb) }
edible-force-feed-success-user = Você alimentou { THE($target) }
