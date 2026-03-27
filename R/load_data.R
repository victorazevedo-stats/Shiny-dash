load_indicator_catalog <- function(path = file.path("config", "indicadores.csv")) {
  if (!file.exists(path)) {
    stop("Catalogo de indicadores nao encontrado em: ", path, call. = FALSE)
  }

  read.csv(path, stringsAsFactors = FALSE)
}

load_dashboard_data <- function(path = file.path("data-processed", "indicadores_municipais_rn.csv")) {
  if (!file.exists(path)) {
    return(example_dashboard_data())
  }

  read.csv(path, stringsAsFactors = FALSE) |>
    transform(
      ano = as.integer(ano),
      valor = as.numeric(valor),
      id_municipio = as.character(id_municipio),
      municipio = as.character(municipio)
    )
}
