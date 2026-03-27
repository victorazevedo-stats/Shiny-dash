library(readr)
library(tidyverse)

pib_pop_RN_2002_2021 <- read_csv("pib_pop_RN_2002_2021.csv")
df_RAIS <- readRDS("D:/victor/UFRN/Dashboard/Projeto/RAIS/df_RAIS.rds")
Valor_adicionado_bruto_a_preços_correntes <- read_delim("D:/victor/UFRN/Dashboard/Projeto/SIDRA/Valor adicionado bruto a preços correntes total (Mil Reais).csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
caged_antigo <- readRDS("D:/victor/UFRN/Dashboard/Projeto/CAGED/caged_antigo.rds")
caged_ajuste <- readRDS("D:/victor/UFRN/Dashboard/Projeto/CAGED/caged_ajuste.rds")

names(pib_pop_RN_2002_2021)
names(df_RAIS)
names(Valor_adicionado_bruto_a_preços_correntes)
names(caged_antigo)
names(caged_ajuste)

glimpse(caged_antigo)
glimpse(caged_ajuste)
glimpse(novo_caged)
glimpse(novo_caged_fp)

library(dplyr)
library(stringr)
library(lubridate)
library(tidyr)

# 1) Função para criar a competência
make_comp <- function(df) {
  # caso tenha ano/mes como integer64, converta para integer
  conv_int <- function(x) if (inherits(x, "integer64")) as.integer(x) else as.integer(x)
  
  if ("competencia_movimentacao" %in% names(df) && any(!is.na(df$competencia_movimentacao))) {
    df <- df %>%
      mutate(
        comp = ifelse(!is.na(competencia_movimentacao),
                      competencia_movimentacao,
                      sprintf("%04d-%02d", conv_int(ano), conv_int(mes)))
      )
  } else if (all(c("ano_competencia_movimentacao", "mes_competencia_movimentacao") %in% names(df))) {
    df <- df %>%
      mutate(
        comp = sprintf("%04d-%02d",
                       conv_int(ano_competencia_movimentacao),
                       conv_int(mes_competencia_movimentacao))
      )
  } else {
    df <- df %>%
      mutate(
        comp = sprintf("%04d-%02d", conv_int(ano), conv_int(mes))
      )
  }
  
  df %>%
    mutate(
      ano = as.integer(substr(comp, 1, 4)),
      mes = as.integer(substr(comp, 6, 7))
    )
}
# 2) Normalizações auxiliares (sexo e evento)
map_sexo_old <- function(x) {
  # Antigo: "01"=Homem, "02"=Mulher (padrão mais comum)
  # Se a sua documentação local divergir, ajuste aqui.
  recode(x, "01"="Homem", "02"="Mulher", .default = x)
}

infer_evento_by_saldo <- function(saldo) ifelse(saldo >= 1, "Admissão",
                                                ifelse(saldo <= -1, "Desligamento", NA))

# 3) Harmonizar CAGED antigo (base principal)
caged_antigo_std <- caged_antigo %>%
  filter(sigla_uf == "RN") %>%
  make_comp() %>%
  mutate(
    sexo = map_sexo_old(sexo),
    evento = infer_evento_by_saldo(saldo_movimentacao),
    cnae_secao = coalesce(cnae_2_descricao_secao, cnae_1_descricao_secao),
    cnae_subclasse = coalesce(cnae_2_subclasse, cnae_1),  # escolha uma preferência
    cbo_2002 = cbo_2002,
    horas = quantidade_horas_contratadas,
    salario = salario_mensal,
    fonte = "antigo"
  ) %>%
  select(comp, ano, mes, sigla_uf, id_municipio, id_municipio_nome,
         evento, saldo_movimentacao,
         cnae_secao, cnae_subclasse, cbo_2002,
         sexo, idade, grau_instrucao,
         horas, salario, fonte)

# 4) Harmonizar CAGED ajuste
caged_ajuste_std <- caged_ajuste %>%
  filter(sigla_uf == "RN") %>%
  make_comp() %>%
  mutate(
    sexo   = map_sexo_old(sexo),
    evento = infer_evento_by_saldo(saldo_movimentacao),
    
    # Pega a primeira coluna que existir no data frame:
    cnae_secao = if ("cnae_2_descricao_secao" %in% names(cur_data())) {
      cnae_2_descricao_secao
    } else if ("cnae_1_descricao_secao" %in% names(cur_data())) {
      cnae_1_descricao_secao
    } else if ("cnae_1_descricao" %in% names(cur_data())) {
      # fallback bem conservador (raro precisar)
      cnae_1_descricao
    } else {
      NA_character_
    },
    
    cnae_subclasse = if ("cnae_2_subclasse" %in% names(cur_data())) {
      cnae_2_subclasse
    } else if ("cnae_1" %in% names(cur_data())) {
      cnae_1
    } else {
      NA_character_
    },
    
    cbo_2002 = cbo_2002,
    horas    = quantidade_horas_contratadas,
    
    # ⚠️ checar unidade do salário no AJUSTE (pode estar em outra escala).
    salario  = salario_mensal,
    fonte    = "ajuste"
  ) %>%
  select(comp, ano, mes, sigla_uf, id_municipio, id_municipio_nome,
         evento, saldo_movimentacao,
         cnae_secao, cnae_subclasse, cbo_2002,
         sexo, idade, grau_instrucao,
         horas, salario, fonte)

# 5) Harmonizar Novo CAGED (dentro do prazo)
novo_caged_std <- novo_caged %>%
  filter(sigla_uf == "RN") %>%
  make_comp() %>%
  mutate(
    evento = infer_evento_by_saldo(saldo_movimentacao),
    cnae_secao = coalesce(cnae_2_secao, cnae_2_descricao_secao),
    cnae_subclasse = cnae_2_subclasse,
    horas = coalesce(horas_contratuais, as.numeric(NA)),
    salario = salario_mensal,
    fonte = "prazo"
  ) %>%
  select(comp, ano, mes, sigla_uf, id_municipio, id_municipio_nome,
         evento, saldo_movimentacao,
         cnae_secao, cnae_subclasse, cbo_2002,
         sexo, idade, grau_instrucao,
         horas, salario, fonte)

# 6) Harmonizar Novo CAGED (fora do prazo)
novo_caged_fp_std <- novo_caged_fp %>%
  filter(sigla_uf == "RN") %>%
  make_comp() %>%
  mutate(
    evento = infer_evento_by_saldo(saldo_movimentacao),
    cnae_secao = coalesce(cnae_2_secao, cnae_2_descricao_secao),
    cnae_subclasse = cnae_2_subclasse,
    horas = coalesce(horas_contratuais, as.numeric(NA)),
    salario = salario_mensal,
    fonte = "fora_prazo"
  ) %>%
  select(comp, ano, mes, sigla_uf, id_municipio, id_municipio_nome,
         evento, saldo_movimentacao,
         cnae_secao, cnae_subclasse, cbo_2002,
         sexo, idade, grau_instrucao,
         horas, salario, fonte)

# 7) Aplicar "precedência do ajuste" no período antigo
# Estratégia prática: agregar no nível de saída e somar base+ajuste,
# mas marcando a fonte para auditoria. Se quiser "substituir", agregue
# separadamente e some os totais (o ajuste já corrige o saldo agregado).
caged_antigo_all <- bind_rows(caged_antigo_std, caged_ajuste_std)

caged_antigo_agregado <- caged_antigo_all %>%
  group_by(comp, ano, mes, id_municipio, id_municipio_nome) %>%
  summarise(
    admitidos = sum(evento == "Admissão", na.rm = TRUE),
    desligados = sum(evento == "Desligamento", na.rm = TRUE),
    saldo = sum(saldo_movimentacao, na.rm = TRUE),
    salario_medio = mean(salario, na.rm = TRUE),
    horas_medias = mean(horas, na.rm = TRUE),
    .groups = "drop"
  )

# 8) Unir Novo CAGED: dentro do prazo + fora do prazo
novo_caged_all <- bind_rows(novo_caged_std, novo_caged_fp_std)

novo_caged_agregado <- novo_caged_all %>%
  group_by(comp, ano, mes, id_municipio, id_municipio_nome) %>%
  summarise(
    admitidos = sum(evento == "Admissão", na.rm = TRUE),
    desligados = sum(evento == "Desligamento", na.rm = TRUE),
    saldo = sum(saldo_movimentacao, na.rm = TRUE),
    salario_medio = mean(salario, na.rm = TRUE),
    horas_medias = mean(horas, na.rm = TRUE),
    .groups = "drop"
  )

# 9) Série única RN 2007–2025
caged_RN_2007_2025 <- bind_rows(
  caged_antigo_agregado,
  novo_caged_agregado
) %>%
  arrange(comp, id_municipio)

# 10) Checagens úteis
# (a) saldo = admitidos - desligados?
check_saldo <- caged_RN_2007_2025 %>%
  mutate(ok = (saldo == (admitidos - desligados))) %>%
  summarise(prop_ok = mean(ok, na.rm = TRUE))

# (b) cobertura temporal por município
cobertura <- caged_RN_2007_2025 %>%
  group_by(id_municipio) %>%
  summarise(min_comp = min(comp), max_comp = max(comp), n_meses = n(), .groups="drop")
