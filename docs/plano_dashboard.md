# Plano do dashboard

## Objetivo

Criar um dashboard interativo com comparacao municipal dos principais indicadores economicos do Rio Grande do Norte.

## Unidade de analise

- municipio
- ano

## Estrutura analitica recomendada

### 1. Panorama geral

- mapa coropletico por indicador
- ranking dos municipios
- cards com destaques do ano selecionado

### 2. Dinamica temporal

- serie historica por municipio
- comparacao entre municipio, media do RN e municipio de referencia
- variacao anual e acumulada

### 3. Estrutura economica

- composicao do VAB por setor
- participacao setorial do emprego formal
- concentracao de atividade economica

### 4. Mercado de trabalho

- admissoes
- desligamentos
- saldo
- estoque
- remuneracao media

## Visualizacoes mais adequadas

- `value_box` para destaques
- mapa para distribuicao espacial
- linha para evolucao temporal
- barra horizontal para ranking
- barra empilhada para estrutura setorial
- dispersao para relacao entre dois indicadores
- tabela para consulta detalhada e exportacao

## Regras de padronizacao

- usar codigo IBGE como chave principal
- evitar nomes de municipio como chave
- guardar valores numericos em formato numerico, sem simbolos
- documentar unidade e origem de cada indicador
- padronizar nomes de colunas em `snake_case`
- nunca misturar dado bruto com dado tratado na mesma pasta

## MVP recomendado

Montar a primeira versao com:

- PIB municipal
- PIB per capita
- VAB por setor
- estoque de empregos formais
- saldo do CAGED
- remuneracao media formal

## Expansoes futuras

- indicadores de arrecadacao
- exportacoes
- empresas ativas
- pobreza ou vulnerabilidade
- educacao e demografia como camadas explicativas
