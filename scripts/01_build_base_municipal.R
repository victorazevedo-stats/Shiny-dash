library(dplyr)
library(readr)

indicadores <- read_csv("config/indicadores.csv", show_col_types = FALSE)

# Este script deve ser adaptado para ler as bases tratadas por fonte e
# consolidar uma unica tabela em formato longo para o app.
base_exemplo <- tibble(
  id_municipio = c("2408102", "2402006", "2403251"),
  municipio = c("Natal", "Caico", "Parnamirim"),
  uf = "RN",
  ano = 2021L,
  indicador = c("pib_total", "pib_total", "pib_total"),
  valor = c(24500000, 980000, 6200000),
  unidade = "mil_reais",
  fonte = "IBGE"
)

write_csv(base_exemplo, "data-processed/indicadores_municipais_rn.csv")

message("Base consolidada criada em data-processed/indicadores_municipais_rn.csv")
