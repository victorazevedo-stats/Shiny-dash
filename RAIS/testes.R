install.packages("bit64")   # se ainda não tiver
library(bit64)
library(tidyverse)

n_distinct(df_RAIS$ano)
sort(unique(df_RAIS$ano))


df_RAIS <- df_RAIS |>
  mutate(
    ano = as.integer(ano),
    indicador_rais_negativa = as.integer(indicador_rais_negativa),
    quantidade_vinculos_ativos = as.integer(quantidade_vinculos_ativos),
    quantidade_vinculos_clt = as.integer(quantidade_vinculos_clt),
    quantidade_vinculos_estatutarios = as.integer(quantidade_vinculos_estatutarios),
    indicador_cei_vinculado = as.integer(indicador_cei_vinculado),
    indicador_pat = as.integer(indicador_pat),
    indicador_atividade_ano = as.integer(indicador_atividade_ano)
    )

df_RAIS <- df_RAIS |> filter(ano >= 2002)

saveRDS(df_RAIS, "df_RAIS.rds")

