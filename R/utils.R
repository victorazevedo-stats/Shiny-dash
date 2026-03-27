example_dashboard_data <- function() {
  data.frame(
    id_municipio = c("2408102", "2402006", "2403251", "2408003", "2412203"),
    municipio = c("Natal", "Caico", "Parnamirim", "Mossoro", "Sao Goncalo do Amarante"),
    uf = "RN",
    ano = c(2021L, 2021L, 2021L, 2021L, 2021L),
    indicador = c("pib_per_capita", "pib_per_capita", "pib_per_capita", "pib_per_capita", "pib_per_capita"),
    valor = c(30850.12, 18420.55, 26540.90, 29210.73, 23880.11),
    unidade = "reais_por_habitante",
    fonte = "IBGE",
    stringsAsFactors = FALSE
  )
}
