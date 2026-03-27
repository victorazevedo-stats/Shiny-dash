# Dashboard Shiny: Indicadores Economicos dos Municipios do RN

Este repositorio foi organizado para desenvolver um dashboard em `R + Shiny` sobre os indicadores economicos do Rio Grande do Norte por municipio, com foco em:

- padronizacao de bases de diferentes fontes;
- atualizacao futura com o menor retrabalho possivel;
- separacao clara entre dados brutos, dados tratados, scripts e aplicacao.

## Pergunta central

Como os municipios do Rio Grande do Norte evoluem em emprego, renda, atividade economica e estrutura produtiva ao longo do tempo?

## Estrutura do projeto

```text
.
|-- app/                  # UI, server e modulos do dashboard
|-- R/                    # funcoes reutilizaveis
|-- scripts/              # pipeline de importacao, limpeza e consolidacao
|-- data-raw/             # dados brutos recebidos ou baixados
|-- data-processed/       # bases padronizadas prontas para analise
|-- config/               # metadados e configuracoes
|-- docs/                 # decisoes analiticas e padroes do projeto
|-- outputs/              # relatorios, figuras e exportacoes
|-- CAGED/ RAIS/ SIDRA/ pib/  # pastas legadas ainda nao migradas
```

## Fluxo recomendado

1. Colocar ou atualizar os arquivos brutos em `data-raw/`.
2. Rodar scripts de importacao por fonte em `scripts/`.
3. Salvar uma base padronizada por fonte em `data-processed/`.
4. Gerar uma base consolidada municipal para o dashboard.
5. Consumir apenas as bases em `data-processed/` dentro do app Shiny.

## Padrao de identificacao

Toda base municipal deve ter, no minimo, estas colunas:

- `ano`
- `id_municipio` (codigo IBGE)
- `municipio`
- `uf`
- `fonte`
- `indicador`
- `valor`
- `unidade`

Quando possivel, inclua tambem:

- `categoria`
- `subcategoria`
- `recorte`
- `nota_metodologica`
- `data_atualizacao`

## Indicadores prioritarios

- PIB municipal total
- PIB per capita
- Valor adicionado bruto por setor
- Estoque de empregos formais (RAIS)
- Admissoes, desligamentos e saldo (CAGED)
- Remuneracao media formal
- Participacao setorial no emprego

## Como executar o app

No R:

```r
source("app/app.R")
```

Ou:

```r
shiny::runApp("app")
```

## Proximos passos sugeridos

- migrar as bases atuais para `data-raw/` e `data-processed/`;
- definir a lista final de indicadores do MVP;
- construir a primeira base consolidada municipal;
- ligar os filtros e graficos no Shiny.
