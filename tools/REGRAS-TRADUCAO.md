# Regras de Tradução — SS14 pt-BR

## O que NUNCA mudar
- Chaves Fluent: `key = value` — a chave nunca muda
- Placeables: `{ $variavel }`, `{ FUNCTION($x) }`, `{ -termo }`, seletores `{ $x -> [...] }`
- Tags SS14 (case-sensitive): `[color=...]`, `[/color]`, `[bold]`, `[italic]`, `[head=N]`, `[keybind=...]`
- Atributos XML: `Entity=`, `Group=`, `Caption=`, `link=`
- Comentários Fluent: linhas que começam com `#`
- IDs de dataset (chaves): `names-vox-dataset-42` etc.
- Nomes próprios de jogo: Nanotrasen, Syndicat, EMAG, RCD, mechs, espécies Vox/Diona

## O que traduzir
- Texto humano dentro de `= valor` (depois do `=`)
- Texto dentro de variantes Fluent: `[key] TEXTO *[other] TEXTO`
- Caption= de GuideEntityEmbed (rótulo visível ao jogador)
- Texto de parágrafos XML do guidebook

## Datasets de nomes próprios — NÃO traduzir
Estes datasets contêm nomes de pessoas/lugares que devem permanecer como no en-US:
- `datasets/names/first*.ftl` — nomes de pessoas
- `datasets/names/last*.ftl` — sobrenomes
- `datasets/names/vox.ftl` — nomes alienígenas Vox
- `datasets/names/diona.ftl` — nomes Diona
- `accent/*.ftl` — palavras do dicionário de sotaque (kept as-is or in dialect)

## Datasets que SÊ traduzem (texto visível)
- `datasets/adjectives.ftl`, `datasets/verbs.ftl`
- `datasets/names/cookie_fortune.ftl` — frases de biscoito da sorte
- `datasets/figurines.ftl` — frases de figurinhas
- `datasets/names/operation_prefix.ftl` / `operation_suffix.ftl` — prefixos/sufixos de operação

## Erros comuns do LLM (rejeitar automaticamente)
- "Aqui está a tradução..." — o modelo descreveu o que estava fazendo
- "conjunto de dados N" — o modelo referenciou o dataset em vez de traduzir
- "dataset de nomes" — idem
- Texto de instruções do sistema prompt vazado
