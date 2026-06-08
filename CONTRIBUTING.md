# Guia de Contribuição

Obrigado pelo interesse em contribuir! Este guia explica o fluxo para quem quer ajudar com traduções, correções de código ou qualquer outra melhoria no fork.

Dúvidas? Fale no [Discord](https://discord.gg/mrWMvYZHYB) ou abra uma issue.

---

## Tipos de contribuição

| Tipo | Onde mexer |
|---|---|
| Tradução (textos do jogo) | `Resources/Locale/pt-BR/` |
| Correção de bug no código | `Content.Server/`, `Content.Client/`, `Content.Shared/` |
| Mapa ou protótipo (YAML) | `Resources/Prototypes/`, `Resources/Maps/` |
| Documentação | `README.md`, este arquivo |

---

## Passo a passo

### 1. Fork e clone

```shell
# Clone o repositório
git clone https://github.com/thestarentity/estacao-honk.git
cd estacao-honk

# Inicializa o submódulo RobustToolbox e baixa dependências nativas
python RUN_THIS.py
```

### 2. Crie uma branch

Use um nome curto que descreva o que você vai fazer:

```shell
git checkout -b traducao/itens-medicos
git checkout -b fix/crash-ao-entrar
git checkout -b feat/mapa-novo
```

### 3. Faça as alterações

**Para traduções:**
- Edite somente os arquivos em `Resources/Locale/pt-BR/`
- Nunca altere `Resources/Locale/en-US/` (é a fonte, não a saída)
- Altere somente o texto legível após o `=`; nunca toque em chaves de mensagem, variáveis `{ $var }`, funções Fluent ou comentários `#`

**Para código C#:**
- Siga o estilo do arquivo que você está editando
- Teste localmente antes de abrir PR (`dotnet run --project Content.Server`)

### 4. Padrão de commit

Use mensagens claras em português, com um prefixo de tipo:

```
traducao: traduzir itens médicos (seringas, curativos)
fix: corrigir crash ao abrir mochila vazia
feat: adicionar sala de reunião no mapa Saltern
docs: atualizar instruções de build no README
```

Use mensagens curtas e descritivas, em português.

### 5. Abra um Pull Request

1. Envie a branch para o seu fork: `git push origin nome-da-branch`
2. Abra um PR em [github.com/thestarentity/estacao-honk](https://github.com/thestarentity/estacao-honk)
3. Preencha o template de PR que aparece automaticamente
4. Descreva o que mudou e por que

A equipe vai revisar e dar feedback. PRs de tradução costumam ser aprovados rápido; PRs de código podem levar mais tempo dependendo do escopo.

---

## Reportar um bug

Use o formulário de issue no GitHub. Inclua:
- O que aconteceu
- O que você esperava que acontecesse
- Passos para reproduzir
- Versão do jogo (changelog in-game, canto inferior direito)

Para bugs na engine Robust Toolbox: [RobustToolbox/issues](https://github.com/space-wizards/RobustToolbox/issues).
Para bugs no jogo base (não relacionados à tradução ou ao servidor): [space-station-14/issues](https://github.com/space-wizards/space-station-14/issues).

---

## Regras gerais

- PRs que quebrem a compilação não serão aceitos
- Alterações em `Resources/Locale/en-US/` serão recusadas
- Mantenha o escopo do PR focado: uma coisa por vez é mais fácil de revisar
- Seja respeitoso; siga o [Código de Conduta](CODE_OF_CONDUCT.md)
