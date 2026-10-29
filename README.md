# Homebrew Tap da Nuvem.Online

Catálogo [Homebrew](https://brew.sh) com os aplicativos da Nuvem.Online para macOS.

```sh
brew tap nuvemonline/tap
```

## Aplicativos

| Cask | Aplicativo | Instalação |
| --- | --- | --- |
| `nuvemworks` | [nuvem.works](https://nuvem.works): acesso às áreas de trabalho e aplicações publicadas | `brew install --cask nuvemonline/tap/nuvemworks` |

Os aplicativos se atualizam sozinhos; o cask só instala. Para remover:
`brew uninstall --cask nuvemworks`.

## Ferramentas de linha de comando

| Formula | Ferramenta | Instalação |
| --- | --- | --- |
| `nuveminsure` | CLI do [nuvem.insure](https://nuvem.insure): backup centralizado pelo terminal e por agentes de IA (macOS e Linux) | `brew install nuvemonline/tap/nuveminsure` |

As formulas instalam binários assinados e se atualizam pelo Homebrew: `brew upgrade nuveminsure`.

Este repositório contém apenas as receitas de instalação. O código dos aplicativos não é
publicado aqui.
