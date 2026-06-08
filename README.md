<div align="center">
  <img alt="Estação Honk" width="860" src="assets/logo.png">
  <br/><br/>

  [![Licença MIT](https://img.shields.io/badge/código-MIT-blue?style=flat-square)](LICENSE.TXT)
  [![Assets CC-BY-SA](https://img.shields.io/badge/assets-CC--BY--SA%203.0-green?style=flat-square)](https://creativecommons.org/licenses/by-sa/3.0/)
  [![Discord](https://img.shields.io/badge/Discord-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/mrWMvYZHYB)

  [Como Jogar](#como-jogar) · [Tradução](#tradução-pt-br) · [Desenvolvedores](#desenvolvedores) · [Contribuir](#contribuir) · [Licença](#licença)
</div>

---

## Sobre o Projeto

Estação Honk é um fork brasileiro de [Space Station 14](https://github.com/space-wizards/space-station-14), o remake moderno do clássico SS13, construído sobre a engine [Robust Toolbox](https://github.com/space-wizards/RobustToolbox).

O repositório oficial do SS14 não aceita traduções. Este fork mantém uma versão **completamente em português do Brasil**, com servidor dedicado e comunidade local.

| | |
|---|---|
| Tradução pt-BR completa | Mais de 1.100 arquivos de locale: menus, itens, tutoriais, descrições |
| Servidor dedicado | `82.38.28.11:1212` |
| Sincronizado com upstream | Atualizações regulares a partir do repositório oficial |

> [!NOTE]
> O código do jogo, os assets e a engine são os mesmos do upstream. As modificações deste fork se limitam à localização e ao branding do servidor.

---

## Como Jogar

**1. Baixar o launcher**

Instale o launcher oficial: **[spacestation14.com](https://spacestation14.com/about/nightlies/)** (Windows, Linux e macOS).

**2. Criar uma conta**

Crie uma conta gratuita em [account.spacestation14.com](https://account.spacestation14.com/).

**3. Conectar**

No launcher, clique em **Direct Connect** e use o endereço:

```
82.38.28.11:1212
```

**4. Idioma**

Dentro do jogo: **Opções → Interface → Idioma → Português (Brasil)**

**Comunidade:** [discord.gg/mrWMvYZHYB](https://discord.gg/mrWMvYZHYB)

---

## Tradução pt-BR

O SS14 usa o formato [Fluent](https://projectfluent.org/) (arquivos `.ftl`) para todos os textos. Os arquivos traduzidos ficam em `Resources/Locale/pt-BR/`, espelhando a estrutura de `Resources/Locale/en-US/`.

```
Resources/Locale/
├── en-US/     ← fonte oficial (não edite)
└── pt-BR/     ← traduções deste fork
```

### Regras do formato Fluent

> [!WARNING]
> Arquivos `.ftl` com erros de sintaxe impedem o carregamento do jogo. Ao traduzir, altere **somente o texto legível** após o `=`. Nunca toque em chaves de mensagem, variáveis `{ $var }`, funções `{ CAPITALIZE(...) }`, seletores de plural ou comentários `#`.

```fluent
# Correto: só o texto muda
item-crowbar-name = Pé-de-cabra
item-crowbar-desc = Uma ferramenta confiável para todas as ocasiões.
```

<details>
<summary>Ver exemplo com seletores de plural</summary>

```fluent
# en-US
welcome-message = Hello, { $name }! You have { $count ->
    [one] one message.
   *[other] { $count } messages.
} waiting.

# pt-BR: apenas o texto interno muda
welcome-message = Olá, { $name }! Você tem { $count ->
    [one] uma mensagem.
   *[other] { $count } mensagens.
} esperando.
```

</details>

Para contribuir com traduções, abra um Pull Request editando os arquivos em `Resources/Locale/pt-BR/`. Dúvidas sobre terminologia: [Discord](https://discord.gg/mrWMvYZHYB).

---

## Desenvolvedores

### Requisitos

| Ferramenta | Versão |
|---|---|
| [.NET SDK](https://dotnet.microsoft.com/download) | 9.0+ |
| [Python](https://python.org) | 3.8+ |
| Git | qualquer versão |

### Clonar e inicializar

```shell
git clone https://github.com/thestarentity/estacao-honk.git
cd space-station-14
python RUN_THIS.py
```

`RUN_THIS.py` inicializa o submódulo `RobustToolbox` e baixa dependências nativas. Execute na primeira clonagem e após cada atualização de submódulo.

### Compilar

```shell
dotnet build Content.Server   # servidor
dotnet build Content.Client   # cliente
dotnet build                  # tudo
```

### Rodar localmente

```shell
# Terminal 1
dotnet run --project Content.Server

# Terminal 2
dotnet run --project Content.Client
```

O cliente conecta automaticamente em `localhost:1212`.

### Estrutura de pastas

<details>
<summary>Ver estrutura completa</summary>

```
space-station-14/
├── Content.Server/       # lógica do servidor (C#)
├── Content.Client/       # lógica do cliente (C#)
├── Content.Shared/       # código compartilhado (C#)
├── Resources/
│   ├── Locale/
│   │   ├── en-US/        # textos originais
│   │   └── pt-BR/        # traduções deste fork
│   ├── Prototypes/       # entidades e regras em YAML
│   ├── Textures/         # sprites e texturas
│   └── Audio/            # sons e músicas
├── RobustToolbox/        # engine (submódulo, não edite)
├── assets/               # logo e ícone do repositório
└── RUN_THIS.py           # script de inicialização
```

</details>

### Sincronizar com o upstream

```shell
git remote add upstream https://github.com/space-wizards/space-station-14.git
git fetch upstream
git merge upstream/master
```

---

## Contribuir

Pull requests são bem-vindos: traduções, correções de código ou assets.

**Fluxo:**

```shell
git checkout -b minha-mudanca
# faça as alterações
git commit -m "Descrição clara do que foi feito"
# abra um Pull Request com descrição do que mudou e por quê
```

**Onde reportar problemas:**

| Problema | Onde |
|---|---|
| Bug na tradução ou no servidor | [Issues](../../issues) ou [Discord](https://discord.gg/mrWMvYZHYB) |
| Bug na engine Robust Toolbox | [RobustToolbox](https://github.com/space-wizards/RobustToolbox/issues) |
| Bug no jogo base | [space-station-14](https://github.com/space-wizards/space-station-14/issues) |

---

## FAQ

<details>
<summary>O jogo não inicia ou fecha sozinho.</summary>

Verifique se o [.NET 9 Runtime](https://dotnet.microsoft.com/download/dotnet/9.0) está instalado. No terminal: `dotnet --version`.

</details>

<details>
<summary>Não consigo conectar ao servidor.</summary>

Confirme o endereço `82.38.28.11:1212` e verifique se há firewall bloqueando UDP. O servidor pode estar em manutenção; consulte o [Discord](https://discord.gg/mrWMvYZHYB).

</details>

<details>
<summary>Vejo texto em inglês com pt-BR selecionado.</summary>

A tradução é um trabalho em andamento. Você pode ajudar editando o arquivo correspondente em `Resources/Locale/pt-BR/`.

</details>

<details>
<summary>Posso usar este fork para meu próprio servidor?</summary>

Sim. O código é MIT. Verifique as licenças dos assets individualmente e respeite as regras de atribuição (veja a seção Licença).

</details>

<details>
<summary>Como atualizo minha cópia local?</summary>

```shell
git pull origin master
python RUN_THIS.py
```

</details>

---

## Licença

Este projeto é um fork de [Space Station 14](https://github.com/space-wizards/space-station-14), desenvolvido pela [Space Wizards Federation](https://spacestation14.com/). Todo o crédito pelo jogo base pertence aos seus autores.

**Código:** [MIT License](LICENSE.TXT). Copyright (c) 2017-2026 Space Wizards Federation

**Assets:** [CC-BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/) na maioria dos casos. A licença de cada asset está no `meta.json` correspondente.

> [!CAUTION]
> Alguns assets usam [CC-BY-NC-SA 3.0](https://creativecommons.org/licenses/by-nc-sa/3.0/) (não-comercial). Para uso comercial, identifique e remova esses assets antes de publicar.

Ao redistribuir este projeto, consulte as políticas de atribuição obrigatória do upstream:
[Robust Generic Attribution](https://docs.spacestation14.com/en/specifications/robust-generic-attribution.html) · [Robust Station Image](https://docs.spacestation14.com/en/specifications/robust-station-image.html)
