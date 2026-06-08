<div align="center">
  <img alt="Estação Honk" width="880" src="assets/logo.png">

  <h3>Fork brasileiro de Space Station 14 — totalmente traduzido para pt-BR</h3>

  [![Licença MIT](https://img.shields.io/badge/código-MIT-blue?style=flat-square)](LICENSE.TXT)
  [![Assets CC-BY-SA](https://img.shields.io/badge/assets-CC--BY--SA%203.0-green?style=flat-square)](https://creativecommons.org/licenses/by-sa/3.0/)
  [![Discord](https://img.shields.io/badge/Discord-Entrar-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/mrWMvYZHYB)

  [**Discord**](https://discord.gg/mrWMvYZHYB) · [Como Jogar](#-como-jogar) · [Desenvolvedores](#-para-desenvolvedores) · [Contribuir](#-como-contribuir) · [Licença](#-créditos-e-licença)
</div>

---

## 📖 Sobre o Projeto

A **Estação Honk** é um servidor e fork brasileiro de [Space Station 14](https://github.com/space-wizards/space-station-14) — o remake moderno do clássico SS13, desenvolvido pela [Space Wizards Federation](https://spacestation14.com/) e construído sobre a engine [Robust Toolbox](https://github.com/space-wizards/RobustToolbox).

Este fork existe porque o repositório oficial não aceita traduções. Aqui mantemos uma versão **totalmente em português**, com servidor dedicado para a comunidade brasileira.

**O que este fork adiciona ao jogo base:**

| O que | Detalhe |
|---|---|
| 🇧🇷 Tradução pt-BR completa | Mais de 1.100 arquivos de locale traduzidos — menus, itens, tutoriais, descrições |
| 🌐 Servidor dedicado | `82.38.28.11:1212` — hospedado com baixa latência para o Brasil |
| 🔄 Sincronização com upstream | O fork é mantido atualizado com o repositório oficial da Space Wizards |
| 🤝 Comunidade no Discord | Suporte, reportes de bug e discussões em português |

O código do jogo, os assets e a engine permanecem os mesmos do upstream. Modificações de conteúdo neste fork são limitadas à localização e ajustes necessários para o servidor.

---

## 🎮 Como Jogar

### 1. Baixar o launcher

Baixe e instale o launcher oficial do SS14:

**[⬇ Download — spacestation14.com](https://spacestation14.com/about/nightlies/)**

O launcher é compatível com Windows, Linux e macOS.

### 2. Criar uma conta

Crie uma conta gratuita em **[account.spacestation14.com](https://account.spacestation14.com/)** — necessária para jogar em servidores online.

### 3. Conectar ao servidor

No launcher, clique em **"Direct Connect"** e cole o endereço abaixo:

```
82.38.28.11:1212
```

### 4. Configurar o idioma para pt-BR

Dentro do jogo, acesse **Opções → Interface → Idioma** e selecione **Português (Brasil)**. O jogo exibirá todo o conteúdo traduzido por este fork.

> Se algum texto ainda aparecer em inglês, aquela tela ou item pode ainda estar sem tradução. Contribuições são bem-vindas — veja a seção [Tradução pt-BR](#-tradução-pt-br).

### 5. Comunidade

Dúvidas, bugs, sugestões e bate-papo:

**[➡ Entrar no Discord](https://discord.gg/mrWMvYZHYB)**

---

## 🌐 Tradução pt-BR

### Como funciona

O SS14 usa o formato **[Fluent](https://projectfluent.org/)** (arquivos `.ftl`) para todos os textos do jogo. Cada arquivo em `Resources/Locale/en-US/` tem um equivalente traduzido em `Resources/Locale/pt-BR/`.

Estrutura:

```
Resources/Locale/
├── en-US/          ← fonte oficial (não edite)
└── pt-BR/          ← traduções deste fork
    ├── entities/
    ├── ui/
    ├── game-ticking/
    └── ...
```

### Regras do formato Fluent

O formato Fluent tem sintaxe estrita. Ao traduzir, **só altere o texto legível por humanos**. Nunca toque em:

- Chaves de mensagem: `nome-do-item =` (parte antes do `=`)
- Variáveis: `{ $nome }`, `{ $count }`
- Funções: `{ CAPITALIZE($x) }`, `{ THE($x) }`
- Seletores e ramificações: `{ $x -> [one] ... *[other] ... }`
- Comentários: linhas que começam com `#`
- Atributos: `.name =`, `.desc =`

**Exemplo correto:**

```fluent
# Antes (en-US)
item-crowbar-name = Crowbar
item-crowbar-desc = A trusty tool for all occasions.

# Depois (pt-BR) — só o texto muda
item-crowbar-name = Pé-de-cabra
item-crowbar-desc = Uma ferramenta confiável para todas as ocasiões.
```

### Como ajudar a traduzir

1. Faça fork deste repositório
2. Localize o arquivo correspondente em `Resources/Locale/pt-BR/`
3. Edite apenas o texto após o `=`, respeitando as regras acima
4. Abra um Pull Request com a tradução
5. Valide que não há erros de parse — arquivos `.ftl` quebrados travam o jogo

Para dúvidas sobre terminologia, entre no Discord — mantemos um glossário de termos padronizados.

---

## 🛠 Para Desenvolvedores

### Pré-requisitos

| Ferramenta | Versão mínima | Para quê |
|---|---|---|
| [.NET SDK](https://dotnet.microsoft.com/download) | 9.0 | Compilar e rodar o jogo |
| [Python](https://python.org) | 3.8+ | Script de inicialização (`RUN_THIS.py`) |
| Git | qualquer | Clonar e atualizar submódulos |

> **Windows:** recomendado o [Visual Studio 2022](https://visualstudio.microsoft.com/) ou [Rider](https://www.jetbrains.com/rider/). **Linux/macOS:** `dotnet` via linha de comando funciona direto.

### Clonar o repositório

```shell
git clone https://github.com/thestarentity/space-station-14.git
cd space-station-14
python RUN_THIS.py
```

O `RUN_THIS.py` inicializa o submódulo `RobustToolbox` (engine) e baixa dependências. É necessário rodá-lo na primeira clonagem e após cada atualização de submódulo.

### Compilar

```shell
# Apenas o servidor
dotnet build Content.Server

# Apenas o cliente
dotnet build Content.Client

# Tudo de uma vez
dotnet build
```

### Rodar localmente

Em dois terminais separados:

```shell
# Terminal 1 — servidor
dotnet run --project Content.Server

# Terminal 2 — cliente (conecta automaticamente ao servidor local)
dotnet run --project Content.Client
```

O cliente local se conecta por padrão em `localhost:1212`. Para testar a tradução pt-BR, configure o idioma nas opções do jogo.

### Estrutura de pastas principal

```
space-station-14/
├── Content.Server/         ← código C# do servidor
├── Content.Client/         ← código C# do cliente
├── Content.Shared/         ← código C# compartilhado
├── Resources/
│   ├── Locale/
│   │   ├── en-US/          ← textos originais (não edite)
│   │   └── pt-BR/          ← traduções deste fork
│   ├── Prototypes/         ← definições de entidades em YAML
│   ├── Textures/           ← sprites e texturas
│   └── Audio/              ← sons e músicas
├── RobustToolbox/          ← engine (submódulo git, não edite diretamente)
├── assets/                 ← imagens do repositório (logo, ícone)
├── RUN_THIS.py             ← script de inicialização
└── LICENSE.TXT             ← licença MIT
```

> **Atenção:** `RobustToolbox/` é um submódulo git apontando para a engine oficial. Não faça commits diretos nessa pasta — mudanças na engine devem ir para o repositório upstream da engine.

### Sincronizar com o upstream

Para trazer mudanças do repositório oficial do SS14 para este fork:

```shell
# Adicionar o upstream (só na primeira vez)
git remote add upstream https://github.com/space-wizards/space-station-14.git

# Buscar e fazer merge
git fetch upstream
git merge upstream/master
```

Após o merge, verifique se alguma tradução em `pt-BR` foi sobrescrita por arquivos novos em `en-US` que ainda não têm equivalente.

---

## 🤝 Como Contribuir

Contribuições são bem-vindas — de correções de tradução a melhorias de código.

### Fluxo de Pull Request

1. **Fork** este repositório e crie um branch descritivo:
   ```shell
   git checkout -b traducao/corrige-itens-medicos
   # ou
   git checkout -b fix/bug-descricao-entity
   ```

2. **Faça suas mudanças** e commite com mensagem clara:
   ```shell
   git commit -m "Corrige tradução de itens médicos em medical.ftl"
   ```

3. **Abra um Pull Request** descrevendo:
   - O que foi alterado e por quê
   - Se é tradução: quais arquivos `.ftl` foram tocados
   - Se é código: qual comportamento muda

4. **Aguarde revisão.** PRs de tradução são revisados por membros da comunidade no Discord.

### Padrão de commits

- **Português ou inglês** — ambos são aceitos
- **Mensagem descritiva** — diga o que muda, não só "fix" ou "update"
- **Um assunto por commit** — não misture tradução com mudança de código no mesmo commit

```shell
# Bom
git commit -m "Traduz 47 entidades de estruturas em structures.ftl"
git commit -m "Corrige selector de plural em items/food.ftl"

# Evite
git commit -m "fixes"
git commit -m "update"
```

### Reportar bugs

- **Bugs no jogo ou na tradução:** abra uma issue neste repositório ou reporte no [Discord](https://discord.gg/mrWMvYZHYB)
- **Bugs na engine (Robust Toolbox):** reporte em [github.com/space-wizards/RobustToolbox](https://github.com/space-wizards/RobustToolbox)
- **Bugs no jogo base (upstream):** reporte em [github.com/space-wizards/space-station-14](https://github.com/space-wizards/space-station-14)

---

## ❓ FAQ

**O jogo não inicia / trava ao abrir.**
Verifique se o [.NET 9 Runtime](https://dotnet.microsoft.com/download/dotnet/9.0) está instalado. No Linux, certifique-se de que o runtime (não só o SDK) está presente.

**Não consigo conectar ao servidor.**
Confirme que o endereço é exatamente `82.38.28.11:1212` e que não há firewall bloqueando UDP. O servidor pode estar offline para manutenção — verifique o status no Discord.

**Vejo texto em inglês mesmo com pt-BR selecionado.**
Nem todos os textos estão traduzidos — é um trabalho em andamento. Você pode ajudar traduzindo o arquivo correspondente em `Resources/Locale/pt-BR/`.

**Posso usar este fork para criar meu próprio servidor?**
Sim. O código está sob licença MIT. Verifique as licenças dos assets individualmente (a maioria é CC-BY-SA 3.0) e leia as regras de atribuição obrigatória nos links da seção de licença.

**Como atualizo minha cópia local com as últimas mudanças?**
```shell
git pull origin master
python RUN_THIS.py   # atualiza submódulos se necessário
```

---

## 📄 Créditos e Licença

Este projeto é um fork de **[Space Station 14](https://github.com/space-wizards/space-station-14)**, desenvolvido e mantido pela [Space Wizards Federation](https://spacestation14.com/). Todo o crédito pelo jogo base, engine e assets pertence aos seus respectivos autores.

### Licença do código

O código-fonte deste repositório está licenciado sob a **[MIT License](LICENSE.TXT)**.

```
Copyright (c) 2017-2026 Space Wizards Federation
```

### Licença dos assets

A maioria dos assets (sprites, sons, texturas) está licenciada sob **[CC-BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/)**, salvo indicação contrária. A licença e o autor de cada asset estão especificados no arquivo `meta.json` correspondente.

> ⚠️ **Uso comercial:** Alguns assets utilizam [CC-BY-NC-SA 3.0](https://creativecommons.org/licenses/by-nc-sa/3.0/) (não-comercial). Para uso comercial, identifique e remova esses assets antes de publicar.

### Atribuição obrigatória

Ao fazer fork ou redistribuir este projeto, consulte as políticas de atribuição do upstream:

- [Robust Generic Attribution](https://docs.spacestation14.com/en/specifications/robust-generic-attribution.html)
- [Robust Station Image](https://docs.spacestation14.com/en/specifications/robust-station-image.html)
