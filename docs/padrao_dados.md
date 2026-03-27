# Padrao de dados do projeto

## Camadas

### Dados brutos

Arquivos recebidos ou baixados sem alteracao manual. Devem ficar em `data-raw/`.

### Dados processados

Bases limpas e padronizadas, prontas para analise e para o app. Devem ficar em `data-processed/`.

### Dados analiticos

Tabelas consolidadas e derivadas para consumo direto do dashboard.

## Chaves obrigatorias

- `id_municipio`
- `municipio`
- `uf`
- `ano`

## Estrutura longa recomendada

Formato ideal para integrar fontes diferentes:

- `id_municipio`
- `municipio`
- `uf`
- `ano`
- `indicador`
- `valor`
- `unidade`
- `fonte`
- `categoria`
- `subcategoria`

## Convencoes

- datas em ISO (`YYYY-MM-DD`)
- codigos como texto quando houver zeros a esquerda
- `id_municipio` com 7 digitos
- arquivos processados com nome descritivo, por exemplo:
  - `rais_municipio_anual.parquet`
  - `caged_municipio_mensal.parquet`
  - `indicadores_municipais_rn.parquet`

## Controle de atualizacao

Cada script de processamento deve:

1. ler apenas de `data-raw/`;
2. escrever apenas em `data-processed/`;
3. registrar a fonte usada;
4. registrar a data da atualizacao;
5. ser idempotente, isto e, rodar de novo sem quebrar a estrutura.
