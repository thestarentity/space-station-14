<div align="center">
  <img alt="Estação Honk" width="880" src="assets/logo.png">

  <br/>
  <img alt="Ícone" width="64" src="assets/icon.png">
  <br/><br/>

  <strong>Fork brasileiro de Space Station 14 — totalmente traduzido para pt-BR</strong>

  <br/><br/>

  [![Licença MIT](https://img.shields.io/badge/Código-MIT-blue?style=for-the-badge&logo=opensourceinitiative&logoColor=white)](LICENSE.TXT)
  [![Assets CC-BY-SA](https://img.shields.io/badge/Assets-CC--BY--SA%203.0-green?style=for-the-badge&logo=creativecommons&logoColor=white)](https://creativecommons.org/licenses/by-sa/3.0/)
  [![Discord](https://img.shields.io/badge/Discord-Entrar-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mrWMvYZHYB)
  [![Upstream](https://img.shields.io/badge/Upstream-Space%20Wizards-orange?style=for-the-badge&logo=github&logoColor=white)](https://github.com/space-wizards/space-station-14)

  <br/>

  [🎮 Como Jogar](#-como-jogar) &nbsp;·&nbsp;
  [🌐 Tradução pt-BR](#-tradução-pt-br) &nbsp;·&nbsp;
  [🛠 Desenvolvedores](#-para-desenvolvedores) &nbsp;·&nbsp;
  [🤝 Contribuir](#-como-contribuir) &nbsp;·&nbsp;
  [❓ FAQ](#-faq) &nbsp;·&nbsp;
  [📄 Licença](#-créditos-e-licença)

</div>

---

## 📖 Sobre o Projeto

A **Estação Honk** é um servidor e fork brasileiro de [Space Station 14](https://github.com/space-wizards/space-station-14) — o remake moderno do clássico SS13, desenvolvido pela [Space Wizards Federation](https://spacestation14.com/) sobre a engine [Robust Toolbox](https://github.com/space-wizards/RobustToolbox).

O repositório oficial do SS14 não aceita traduções. Este fork existe para manter uma versão **completamente em português do Brasil**, com servidor dedicado e comunidade local.

**O que este fork adiciona:**

| | O que | Detalhe |
|---|---|---|
| 🇧🇷 | **Tradução completa pt-BR** | Mais de 1.100 arquivos de locale — menus, itens, tutoriais, descrições |
| 🎨 | **Identidade visual própria** | Logo, ícone e assets visuais da Estação Honk |
| 🌐 | **Servidor dedicado** | `82.38.28.11:1212` — hospedado para a comunidade brasileira |
| 🔄 | **Sincronizado com upstream** | Mantemos o fork atualizado com as releases oficiais |
| 🤝 | **Comunidade no Discord** | Suporte, reportes e discussões em português |

> [!NOTE]
> O código do jogo, os assets e a engine permanecem os mesmos do upstream oficial. As modificações deste fork são limitadas à localização e ao branding do servidor.

---

## 🎮 Como Jogar

### 1. Baixar o launcher

Instale o launcher oficial do Space Station 14:

**[⬇ Download — spacestation14.com](https://spacestation14.com/about/nightlies/)**

Compatível com **Windows**, **Linux** e **macOS**.

### 2. Criar uma conta

Crie uma conta gratuita em **[account.spacestation14.com](https://account.spacestation14.com/)** — obrigatória para jogar em servidores online.

### 3. Conectar ao servidor

No launcher, clique em **Direct Connect** e cole o endereço:

```
82.38.28.11:1212
```

### 4. Selecionar o idioma pt-BR

Dentro do jogo: **Opções → Interface → Idioma → Português (Brasil)**

> [!TIP]
> Se algum texto ainda aparecer em inglês, aquela tela ou item pode ainda não ter tradução. Contribuições de tradução são muito bem-vindas — veja a seção [Tradução pt-BR](#-tradução-pt-br).

### 5. Comunidade

Dúvidas, reportes de bug, sugestões e bate-papo:

[![Discord](https://img.shields.io/badge/Entrar_no_Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/mrWMvYZHYB)

---

## 🌐 Tradução pt-BR

### Como funciona

O SS14 usa o formato **[Fluent](https://projectfluent.org/)** (arquivos `.ftl`) para todos os textos. Cada arquivo em `en-US/` tem um equivalente em `pt-BR/`:

```
Resources/Locale/
├── en-US/          ← fonte oficial (nunca edite)
└── pt-BR/          ← traduções deste fork ✏️
    ├── entities/
    ├── ui/
    ├── game-ticking/
    ├── commands/
    └── ...
```

### Regras do formato Fluent

> [!WARNING]
> Arquivos `.ftl` quebrados **travam o jogo inteiro**. Respeite rigorosamente estas regras:

Ao traduzir, **altere apenas o texto legível** após o `=`. Nunca toque em:

```fluent
# ✅ PODE traduzir — só o texto após o =
item-crowbar-name = Pé-de-cabra
item-crowbar-desc = Uma ferramenta confiável para todas as ocasiões.

# ❌ NUNCA altere estas partes:
item-crowbar-name =        ← chave de mensagem
{ $count }                 ← variável
{ CAPITALIZE($x) }         ← função built-in
{ $x -> [one] ... }        ← seletor de plural
# comentário               ← comentário Fluent
.desc =                    ← atributo
```

<details>
<summary>📋 Ver exemplo completo correto</summary>

```fluent
# en-US (original — não edite)
welcome-message = Hello, { $name }! You have { $count ->
    [one] one message.
   *[other] { $count } messages.
} waiting.

# pt-BR (tradução correta — só o texto humano muda)
welcome-message = Olá, { $name }! Você tem { $count ->
    [one] uma mensagem.
   *[other] { $count } mensagens.
} esperando.
```

</details>

### Como ajudar a traduzir

1. Faça fork deste repositório
2. Edite o arquivo correspondente em `Resources/Locale/pt-BR/`
3. Teste localmente (`dotnet run --project Content.Client`)
4. Abra um Pull Request descrevendo quais arquivos foram traduzidos
5. Dúvidas sobre terminologia → [Discord](https://discord.gg/mrWMvYZHYB)

---

## 🛠 Para Desenvolvedores

### Pré-requisitos

| Ferramenta | Versão | Para quê |
|---|---|---|
| [.NET SDK](https://dotnet.microsoft.com/download) | **9.0+** | Compilar e rodar o jogo |
| [Python](https://python.org) | 3.8+ | Script de inicialização |
| Git | qualquer | Clonar e gerenciar submódulos |

<details>
<summary>💡 IDEs recomendadas</summary>

- **Windows/macOS/Linux:** [Rider](https://www.jetbrains.com/rider/) (melhor suporte ao projeto)
- **Windows:** [Visual Studio 2022](https://visualstudio.microsoft.com/) com workload ".NET desktop"
- **Qualquer plataforma:** `dotnet` via terminal funciona sem IDE

</details>

### Clonar e inicializar

```shell
git clone https://github.com/thestarentity/space-station-14.git
cd space-station-14
python RUN_THIS.py
```

> [!IMPORTANT]
> Execute `python RUN_THIS.py` na **primeira clonagem** e sempre após atualizar submódulos. Ele inicializa o `RobustToolbox` (a engine) e baixa dependências nativas necessárias.

### Compilar

```shell
# Servidor
dotnet build Content.Server

# Cliente
dotnet build Content.Client

# Tudo de uma vez
dotnet build
```

### Rodar localmente

```shell
# Terminal 1 — servidor local
dotnet run --project Content.Server

# Terminal 2 — cliente (conecta automaticamente em localhost:1212)
dotnet run --project Content.Client
```

### Estrutura de pastas

<details>
<summary>📁 Ver estrutura completa</summary>

```
space-station-14/
│
├── Content.Server/          ← lógica do servidor (C#)
├── Content.Client/          ← lógica do cliente (C#)
├── Content.Shared/          ← código compartilhado (C#)
│
├── Resources/
│   ├── Locale/
│   │   ├── en-US/           ← textos originais (não edite)
│   │   └── pt-BR/           ← traduções deste fork ✏️
│   ├── Prototypes/          ← entidades e regras em YAML
│   ├── Textures/            ← sprites e texturas
│   │   └── Logo/            ← logo e ícone do servidor
│   └── Audio/               ← sons e músicas
│
├── RobustToolbox/           ← engine (submódulo git — não edite diretamente)
├── assets/                  ← imagens do repositório (logo, ícone)
├── RUN_THIS.py              ← script de inicialização
└── LICENSE.TXT              ← licença MIT
```

> **Atenção:** `RobustToolbox/` é um submódulo apontando para a engine oficial. Nunca faça commits diretos nessa pasta.

</details>

### Sincronizar com o upstream

```shell
# Adicionar o remote do upstream (só na primeira vez)
git remote add upstream https://github.com/space-wizards/space-station-14.git

# Buscar e fazer merge com o master oficial
git fetch upstream
git merge upstream/master
```

> [!NOTE]
> Após cada merge com o upstream, verifique se novos arquivos em `en-US/` precisam de equivalentes em `pt-BR/`.

---

## 🤝 Como Contribuir

Contribuições são bem-vindas — de correções de tradução a melhorias de código ou assets.

### Fluxo de Pull Request

```
1. Fork → 2. Branch → 3. Commit → 4. Pull Request → 5. Revisão
```

```shell
# 1. Crie um branch descritivo
git checkout -b traducao/corrige-itens-medicos
# ou
git checkout -b fix/bug-nome-entidade

# 2. Commite com mensagem clara
git commit -m "Corrige tradução de 12 itens médicos em medical.ftl"

# 3. Abra o Pull Request descrevendo o que mudou e por quê
```

### Padrão de commits

| ✅ Bom | ❌ Evite |
|---|---|
| `Traduz 47 entidades de estruturas em structures.ftl` | `fix` |
| `Corrige selector de plural em food.ftl` | `update stuff` |
| `Adiciona tradução do tutorial de sobrevivência` | `changes` |

- Português ou inglês — ambos são aceitos
- Um assunto por commit — não misture tradução com código

### Reportar bugs

<details>
<summary>🐛 Onde reportar cada tipo de problema</summary>

| Tipo de bug | Onde reportar |
|---|---|
| Bug na tradução pt-BR | [Issues deste repo](../../issues) ou [Discord](https://discord.gg/mrWMvYZHYB) |
| Bug no servidor da Estação Honk | [Discord](https://discord.gg/mrWMvYZHYB) |
| Bug na engine (Robust Toolbox) | [RobustToolbox issues](https://github.com/space-wizards/RobustToolbox/issues) |
| Bug no jogo base (upstream) | [SS14 issues](https://github.com/space-wizards/space-station-14/issues) |

</details>

---

## ❓ FAQ

<details>
<summary><strong>O jogo não inicia ou trava ao abrir.</strong></summary>

Verifique se o [.NET 9 Runtime](https://dotnet.microsoft.com/download/dotnet/9.0) está instalado. No Linux, certifique-se de que o **runtime** (não só o SDK) está presente. Tente rodar `dotnet --version` no terminal.

</details>

<details>
<summary><strong>Não consigo conectar ao servidor.</strong></summary>

- Confirme o endereço exato: `82.38.28.11:1212`
- Verifique se há firewall bloqueando conexões UDP
- O servidor pode estar offline para manutenção — consulte o status no [Discord](https://discord.gg/mrWMvYZHYB)

</details>

<details>
<summary><strong>Vejo texto em inglês mesmo com pt-BR selecionado.</strong></summary>

A tradução é um trabalho em andamento — nem todos os textos estão cobertos ainda. Você pode ajudar traduzindo o arquivo correspondente em `Resources/Locale/pt-BR/`. Veja a seção [Tradução pt-BR](#-tradução-pt-br).

</details>

<details>
<summary><strong>Posso usar este fork para criar meu próprio servidor?</strong></summary>

Sim. O código está sob licença MIT. Verifique as licenças dos assets individualmente (a maioria é CC-BY-SA 3.0) e respeite as regras de atribuição obrigatória — veja os links na seção [Licença](#-créditos-e-licença).

</details>

<details>
<summary><strong>Como atualizo minha cópia local?</strong></summary>

```shell
git pull origin master
python RUN_THIS.py   # atualiza submódulos se necessário
```

</details>

<details>
<summary><strong>Tenho um erro de parse em um arquivo .ftl. O que faço?</strong></summary>

Erros de parse no Fluent travam o carregamento do jogo. Abra o arquivo e procure por chaves desbalanceadas `{ }`, seletores mal formados ou texto fora de lugar. O erro no console do jogo geralmente aponta o arquivo e a linha exata.

</details>

---

## 📄 Créditos e Licença

Este projeto é um fork de **[Space Station 14](https://github.com/space-wizards/space-station-14)**, desenvolvido e mantido pela [Space Wizards Federation](https://spacestation14.com/). Todo o crédito pelo jogo base, engine e assets pertence aos seus respectivos autores.

### Licença do código

O código-fonte deste repositório está licenciado sob a **[MIT License](LICENSE.TXT)**:

```
Copyright (c) 2017-2026 Space Wizards Federation
```

### Licença dos assets

A maioria dos assets (sprites, sons, texturas) está licenciada sob **[CC-BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)**, salvo indicação contrária. A licença de cada asset está no `meta.json` correspondente.

> [!CAUTION]
> Alguns assets usam **[CC-BY-NC-SA 3.0](https://creativecommons.org/licenses/by-nc-sa/3.0/)** (não-comercial). Para uso comercial, identifique e remova esses assets antes de publicar.

### Atribuição obrigatória

Ao fazer fork ou redistribuir, consulte:

- 📋 [Robust Generic Attribution](https://docs.spacestation14.com/en/specifications/robust-generic-attribution.html)
- 🖼 [Robust Station Image](https://docs.spacestation14.com/en/specifications/robust-station-image.html)
