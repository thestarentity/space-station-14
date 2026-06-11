# Regras de Tradução — Space Station 14 (pt-BR)

> Este documento é a **fonte única de verdade** para o tradutor humano,
> o script `ss14-translate.py` e os agentes de IA de auditoria.
> Qualquer conflito com outra fonte: este documento prevalece.

---

## 1. Contexto do Jogo — LEIA ANTES DE TRADUZIR

**Space Station 14** é um simulador multiplayer de estação espacial de ficção científica.
Os jogadores controlam **tripulantes** (`crew`) de uma estação administrada pela corporação
fictícia **Nanotrasen**. Cada jogador tem um **cargo** (`job`/`role`): médico, engenheiro,
cientista, oficial de segurança, palhaço, zelador, capitão, etc.

O jogo tem **rodadas** (`rounds`/`shifts`) com começo, meio e fim. Há **antagonistas**
(`antags`) que sabotam a estação. O universo inclui atmosfera, química, cirurgia, naves,
construção, rádios, computadores, robôs (`mechs`), plantas, alienígenas e espionagem.

**Regra de ouro:** pense em como um **jogador brasileiro de SS14 falaria**, não em
tradução de dicionário. O contexto é sempre o jogo, nunca a vida real.

---

## 2. Glossário Canônico

Estas traduções têm prioridade máxima. Não desvie sem editar este documento.

### Termos de jogo (contexto crítico)

| Inglês | pt-BR correto | pt-BR ERRADO (não use) |
|---|---|---|
| playtime | tempo de jogo | ~~tempo de brincadeira~~ |
| play time | tempo de jogo | ~~hora de brincar~~ |
| clipboard | prancheta | ~~área de transferência~~ |
| round | rodada | ~~redondo, round~~ |
| shift | turno | ~~deslocar, mudar~~ |
| crew | tripulação | ~~equipe, pessoal~~ |
| crewmember | tripulante | ~~membro da equipe~~ |
| station | estação | ~~posto, instalação~~ |
| department | departamento | — |
| role / job | cargo | ~~papel, emprego, função~~ |
| antag / antagonist | antag / antagonista | — |
| shuttle | shuttle | — (não traduz) |
| maintenance | manutenção | maint (abrev. aceita) |
| medbay | enfermaria | — |
| bridge | ponte de comando | — |
| head of staff | chefe de departamento | — |
| operative | operativo | — |
| spawn | spawn | — (ou: spawnar) |

### Cargos (tradução canônica)

| Inglês | pt-BR |
|---|---|
| Captain | Capitão |
| Chief Medical Officer | Chefe Médico |
| Chief Engineer | Engenheiro-Chefe |
| Research Director | Diretor de Pesquisa |
| Head of Security | Chefe de Segurança |
| Head of Personnel | Chefe de Pessoal |
| Security Officer | Oficial de Segurança |
| Medical Doctor | Médico |
| Engineer | Engenheiro |
| Scientist | Cientista |
| Chemist | Químico |
| Botanist | Botanista |
| Janitor | Zelador |
| Clown | Palhaço |
| Mime | Mímico |
| Chef | Chef |

### Organizações e lugares

| Inglês | pt-BR |
|---|---|
| Nanotrasen | Nanotrasen |
| Central Command | Comando Central |
| Syndicate | Sindicato |
| Space Station | Estação Espacial |

### Ferramentas e itens

| Inglês | pt-BR |
|---|---|
| crowbar | pé de cabra |
| screwdriver | chave de fenda |
| wrench | chave inglesa |
| wirecutters | alicate |
| airlock | airlock |
| ID card | cartão de identificação |
| PDA | PDA |
| EVA | EVA |
| HUD | HUD |
| RCD | RCD |
| EMAG | EMAG |
| omnitool | omnitool |
| autolathe | autolathe |
| protolathe | protolathe |
| AME | AME |
| APC | APC |
| SMES | SMES |

### Alimentos (nomes próprios — não traduzir a parte específica)

| Item | Regra |
|---|---|
| donk-pocket | donk-pocket (NÃO traduzir) |
| honk-pocket | honk-pocket (NÃO traduzir) |
| berry-pocket | berry-pocket (NÃO traduzir) |
| warm donk-pocket | donk-pocket quente |
| spicy donk-pocket | donk-pocket picante |
| syndi-cakes | syndi-cakes (NÃO traduzir) |
| cotton bagel | cotton bagel (NÃO traduzir) |
| cheesie honkers | cheesie honkers (NÃO traduzir) |
| NutriBar | NutriBar |
| NutriPaste | NutriPaste |
| boritos | boritos |

### Espécies de alienígenas / raças

Usar o nome consagrado na comunidade SS14 BR. Não criar neologismo.

| Nome | Regra |
|---|---|
| Slime | Slime (NÃO "muco" ou "mucila") |
| Vox | Vox |
| Diona | Diona |
| Moth / Mothman | Moth / Mariposa (quando não é nome próprio) |

### Termos gamer (manter em inglês)

`metagaming`, `powergaming`, `griefing`, `griefer`, `roleplay`, `IC`, `OOC`,
`ahelp`, `bwoink`, `ckey`, `spawn`, `spawnar`, `lobby`, `mapping`, `blueprint`

### Mechs (nomes próprios — não traduzir)

`H.O.N.K.`, `HAMTR`, `Ripley`, `Gygax`, `Durand`, `Marauder`

### Plantas (nomes científicos do jogo — não traduzir)

`gatfruit`, `holymelon`, `koibean`

### Armas (siglas/nomes de jogo — não traduzir)

`AKMS`, `C4`, `SMG`, `fulton`, `draco`

### Outros termos fixos

| Inglês | pt-BR |
|---|---|
| Admin | Admin (não traduz) |
| AHelp | AHelp (não traduz) |
| [Redacted] | [Redacted] (não traduz) |
| [locked] | [locked] (não traduz) |
| ticket | ticket |
| Delta / Epsilon / Gamma | Delta / Epsilon / Gama |
| DNA | DNA |
| box | caixa |
| bag | saco |
| bucket | balde |
| slice / slices | fatia / fatias |
| raw | cru |
| frozen | congelado |
| warm | quente |
| outpost | posto avançado |
| nuclear | nuclear |
| spaceacillin | spaceacillin |

---

## 3. O Que NUNCA Traduzir

### 3.1 Estrutura Fluent (obrigatório)

```
# Chave de mensagem — NUNCA mude o lado esquerdo do =
window-title = Tradução aqui

# Variáveis — NUNCA toque em { $nome }
welcome = Olá, { $name }! Você tem { $count ->
    [one] uma mensagem.         ← texto dos variants: PODE traduzir
   *[other] { $count } mensagens.  ← { $count } dentro: NÃO toca
} esperando.

# Funções built-in — NUNCA toque
label = { CAPITALIZE($noun) } está pronto.
label = { THE($item) } foi usado.
label = { INDEFINITE($item) } apareceu.
label = { CONJUGATE-BE($subject) } na sala.

# Atributos — NUNCA traduza o .nome, só o valor
item-foo =
    .name = Nome do item aqui
    .desc = Descrição aqui

# Termos — NUNCA toque em -termo
station-name = { -company-name } Estação Espacial

# Comentários — NUNCA toque (linhas que começam com #)
# Este comentário permanece em inglês
```

### 3.2 Tags de markup SS14 (manter em inglês exato)

```
[color=red]texto[/color]   ← NUNCA traduzir "color", "red" etc.
[bold]texto[/bold]         ← NUNCA traduzir "bold"
[italic]texto[/italic]     ← NUNCA traduzir "italic"
```

Pares `[color=X]...[/color]` DEVEM ser preservados integralmente.
Nunca escreva `[cor=vermelho]`, `[negrito]`, `[itálico]`.

### 3.3 Tags do Guidebook (manter exatas)

```xml
<Document>       </Document>
<Box>            </Box>
<GuideReagentGroupEmbed Group="NomeDoGrupo"/>
<GuideEntityEmbed Entity="NomeDaEntidade"/>
```

Regras:
- Tags de estrutura ficam **sozinhas na linha** — nunca junte texto a elas
- Os atributos `Group=`, `Entity=` **nunca se traduzem**
- O texto **dentro** de `<Document>` e `<Box>` pode ser traduzido

### 3.4 Outros intocáveis

- IDs e nomes de entidade (ex: `ent-FoodDonkPocket`, `ent-WeaponRifleAkms`)
- Comandos de console (ex: `setalertlevel`, `mappause`)
- Nomes de componentes em código (CamelCase em comentários)
- Sotaques (`accent/` — arquivos em `Locale/pt-BR/accent/` são intencionais)
- `Zzz` e outras onomatopeias de jogo

---

## 4. Regras de Qualidade

### 4.1 Nunca invente

Se não tiver certeza de uma tradução, **mantenha o original** e adicione um comentário
de revisão:

```fluent
# REVISÃO: tradução incerta — verificar com jogadores BR
item-very-specific-thing = very specific thing
```

### 4.2 Use "você" informal

```
# Correto
você está sendo atacado!

# Errado
o senhor está sendo atacado!
```

### 4.3 Tom do original

Texto engraçado → engraçado. Urgente → urgente. Técnico → técnico.
Não "melhorar" o texto original — traduza o que está lá.

### 4.4 Entradas de entidade

```fluent
ent-FoodDonkPocket = donk-pocket         ← .name: curto, o nome do item
    .desc = Um lanche compacto e saboroso.  ← .desc: descrição completa
```

---

## 5. Regras de Validação Automática

O script `ss14-translate.py` e os agentes de auditoria **rejeitam automaticamente**
qualquer tradução que:

1. Introduza erros de parse Fluent (chaves desbalanceadas, syntax error)
2. Adicione ou remova chaves (`message-id`)
3. Altere variáveis (`{ $x }` → variável diferente ou ausente)
4. Traduza tags SS14 para português (`[cor=]`, `[negrito]`)
5. Use nomes de cor em português em `[color=]` (ex: `[color=vermelho]`)
6. Deixe tags `[color]` desbalanceadas

---

## 6. Workflow de Tradução

```
1. Rodar auditoria:  /conselho auditar-traducao [area]
   OU script manual: tools/translate --folder <pasta> --dry-run

2. Revisar o diff antes de aplicar

3. Aplicar (via gate de aprovação no Discord ou --apply no script)

4. Arquivos com # REVISÃO: precisam de revisão humana antes do próximo deploy
```

---

*Última atualização: 2026-06-04 — consolidado a partir do glossary.json,
CLAUDE.md e das regras do ss14-translate.py*
