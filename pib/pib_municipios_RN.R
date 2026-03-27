library(tidyverse)
library(janitor)
library(tidyr)

dir_df <- read_csv("br_bd_diretorios_brasil_municipio.csv")
pib_df <- read_csv("br_ibge_pib_municipio.csv")

# Filtrar apenas os municípios do RN
dir_rn <- dir_df |> 
  filter(sigla_uf == "RN")

# Fazer o join (união) pelo id_municipio
pib_rn <- pib_df  |> 
  inner_join(dir_rn, by = "id_municipio")

# Verificar resultado (primeiras linhas e dimensões)
head(pib_rn)
nrow(pib_rn)
unique(pib_rn$sigla_uf)
write_csv(pib_rn, "municipios_RN_pib.csv")

pop_rn<-read_csv("populacao.csv")
pop_rn <- pop_rn|> 
  filter(sigla_uf == "RN")

write_csv(pop_rn, "populacao_rn.csv")

# Testando se temos dados pop para todos os 32 anos(1991-2022) 
test<-pop_rn |> 
  select(ano, id_municipio_nome) |> 
  group_by(id_municipio_nome) |> 
  summarise(anos=n())|> 
  filter(anos<31)


# junção de dados pop com pib e add var per_capita ------------------------
pib_df <- read_csv("municipios_RN_pib.csv")
pop_df <- read_csv("populacao_rn.csv")

pib_pop_RN <- pib_df |>
  filter(ano >= 2002, ano <= 2021) |>
  inner_join(
    pop_df |> filter(ano >= 2002, ano <= 2021),
    by = c("id_municipio", "ano")
  ) |>
  mutate(pib_per_capita = pib / populacao)

write_csv(pib_pop_RN, "pib_pop_RN_2002_2021.csv")
