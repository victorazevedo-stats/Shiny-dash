source(file.path("R", "utils.R"), local = TRUE)
source(file.path("R", "load_data.R"), local = TRUE)
source(file.path("R", "theme.R"), local = TRUE)

library(shiny)
library(bslib)
library(ggplot2)
library(dplyr)

indicadores <- load_indicator_catalog()
base_dashboard <- load_dashboard_data()

ui <- page_sidebar(
  title = "Indicadores economicos do RN",
  theme = dashboard_theme(),
  sidebar = sidebar(
    selectInput(
      "indicador",
      "Indicador",
      choices = indicadores$indicador_nome,
      selected = indicadores$indicador_nome[[1]]
    ),
    selectInput("ano", "Ano", choices = NULL),
    selectInput("municipio", "Municipio", choices = NULL)
  ),
  layout_column_wrap(
    width = 1/3,
    value_box(title = "Municipios", value = textOutput("n_municipios")),
    value_box(title = "Ano selecionado", value = textOutput("ano_selecionado")),
    value_box(title = "Valor medio", value = textOutput("valor_medio"))
  ),
  card(
    full_screen = TRUE,
    card_header("Comparacao municipal"),
    plotOutput("grafico_ranking", height = 420)
  ),
  card(
    full_screen = TRUE,
    card_header("Base carregada"),
    tableOutput("amostra")
  )
)

server <- function(input, output, session) {
  observe({
    req(nrow(base_dashboard) > 0)
    updateSelectInput(
      session,
      "ano",
      choices = sort(unique(base_dashboard$ano)),
      selected = max(base_dashboard$ano, na.rm = TRUE)
    )
    updateSelectInput(
      session,
      "municipio",
      choices = sort(unique(base_dashboard$municipio)),
      selected = sort(unique(base_dashboard$municipio))[[1]]
    )
  })

  dados_filtrados <- reactive({
    req(input$indicador, input$ano)

    indicador_id <- indicadores |>
      filter(indicador_nome == input$indicador) |>
      pull(indicador_id)

    base_dashboard |>
      filter(indicador == indicador_id, ano == input$ano)
  })

  output$n_municipios <- renderText({
    nrow(dados_filtrados())
  })

  output$ano_selecionado <- renderText({
    input$ano
  })

  output$valor_medio <- renderText({
    dados <- dados_filtrados()
    if (nrow(dados) == 0) return("Sem dados")
    format(round(mean(dados$valor, na.rm = TRUE), 2), decimal.mark = ",", big.mark = ".")
  })

  output$grafico_ranking <- renderPlot({
    dados <- dados_filtrados() |>
      arrange(desc(valor)) |>
      slice_head(n = 20)

    validate(need(nrow(dados) > 0, "Nenhum dado encontrado para o filtro selecionado."))

    ggplot(dados, aes(x = reorder(municipio, valor), y = valor)) +
      geom_col(fill = "#2C5282") +
      coord_flip() +
      labs(x = NULL, y = NULL) +
      theme_minimal(base_size = 12)
  })

  output$amostra <- renderTable({
    head(base_dashboard, 10)
  })
}

shinyApp(ui, server)
