<div align="center">

<!-- Substitua a linha abaixo pela sua logo quando tiver o arquivo -->
<!-- <img alt="Estação Honk" width="880" height="300" src="[LOGO]"> -->

# Estação Honk

**Fork brasileiro de Space Station 14 — traduzido para o português do Brasil**

[LINK DISCORD] • [Como Jogar](#como-jogar) • [Contribuir](#contribuindo) • [Licença](#licença)

</div>

---

## O que é a Estação Honk?

A **Estação Honk** é um servidor brasileiro de [Space Station 14](https://github.com/space-wizards/space-station-14) — o remake moderno do clássico SS13, rodando na engine [Robust Toolbox](https://github.com/space-wizards/RobustToolbox).

Este repositório é um fork do jogo original com foco em:

- **Tradução completa para pt-BR** — textos, menus, itens e tutorial em português
- **Servidor dedicado no Brasil** — menos lag, comunidade local
- **Atualizações constantes** — mantemos o fork sincronizado com o upstream oficial

---

## Como Jogar

### Baixar o cliente

1. Baixe o launcher oficial em **[spacestation14.com](https://spacestation14.com/about/nightlies/)**
2. Instale e abra o launcher

### Entrar no servidor

**Direct Connect:** `82.38.28.11:1212`

No launcher, clique em **"Direct Connect"** e cole o endereço acima. Você precisará de uma conta no [site do SS14](https://account.spacestation14.com/) para jogar.

### Comunidade

Entre no nosso Discord para tirar dúvidas, reportar bugs e participar da comunidade:

> **Discord:** [LINK DISCORD]

---

## Contribuindo

Esta seção é para **mantenedores e colaboradores** que queiram ajudar a desenvolver o fork.

### Pré-requisitos

- [.NET 9 SDK](https://dotnet.microsoft.com/download)
- [Python 3.8+](https://python.org) (para scripts de build)
- Git

### Clonar o repositório

```shell
git clone https://github.com/thestarentity/space-station-14.git
cd space-station-14
python RUN_THIS.py
```

O script `RUN_THIS.py` inicializa os submódulos e prepara o ambiente automaticamente.

### Compilar

```shell
# Compilar o servidor
dotnet build Content.Server

# Compilar o cliente
dotnet build Content.Client
```

### Rodar localmente

```shell
# Servidor
dotnet run --project Content.Server

# Cliente (em outro terminal)
dotnet run --project Content.Client
```

### Enviar uma contribuição

1. Crie um branch a partir do `master`:
   ```shell
   git checkout -b minha-mudanca
   ```
2. Faça suas alterações e commite:
   ```shell
   git add .
   git commit -m "Descrição clara do que foi feito"
   ```
3. Abra um **Pull Request** para este repositório com uma descrição do que mudou e por quê.

### Tradução (arquivos `.ftl`)

Os textos do jogo ficam em `Resources/Locale/pt-BR/`. Para contribuir com traduções, consulte as convenções do projeto antes de editar — o formato Fluent tem regras estritas que, se quebradas, travam o jogo.

---

## Créditos e Licença

Este projeto é um fork de [Space Station 14](https://github.com/space-wizards/space-station-14), desenvolvido pela [Space Wizards Federation](https://spacestation14.com/).

### Licença do código

Todo o código deste repositório está licenciado sob a [MIT License](LICENSE.TXT).

Copyright (c) 2017-2026 Space Wizards Federation

### Licença dos assets

A maioria dos assets (sprites, sons, texturas) está licenciada sob [CC-BY-SA 3.0](https://creativecommons.org/licenses/by-sa/3.0/), salvo indicação contrária. Cada asset tem sua licença especificada no arquivo `meta.json` correspondente.

> **Atenção:** Alguns assets usam [CC-BY-NC-SA 3.0](https://creativecommons.org/licenses/by-nc-sa/3.0/) (não-comercial). Caso queira usar este projeto comercialmente, verifique e remova os assets com restrição não-comercial antes.

Para mais detalhes sobre atribuição, consulte:
- [Robust Generic Attribution](https://docs.spacestation14.com/en/specifications/robust-generic-attribution.html)
- [Robust Station Image](https://docs.spacestation14.com/en/specifications/robust-station-image.html)
