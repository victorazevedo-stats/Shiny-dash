library(tidyverse)
library(purrr)
library(janitor)
library(tidyr)
library(dplyr)
library(ggplot2)
library(scales)

pib_pop_RN<-read.csv("pib_pop_RN_2002_2021.csv")

# Evolução do PIB total do RN (2002–2021)
pib_pop_RN |>
  group_by(ano) |>
  summarise(pib_total = sum(pib, na.rm = TRUE)) |>
  ggplot(aes(x = ano, y = pib_total)) +
  geom_line(linewidth = 1.1, color = "#0072B2") +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(title = "Evolução do PIB total do RN (2002–2021)",
       x = "Ano", y = "PIB total (R$ mil)") +
  theme_minimal()

# Evolução da População total do RN
pib_pop_RN |>
  group_by(ano) |>
  summarise(media_pc = mean(pib_per_capita, na.rm = TRUE)) |>
  ggplot(aes(x = ano, y = media_pc)) +
  geom_line(linewidth = 1.1, color = "#E69F00") +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(title = "Evolução do PIB per capita médio – RN (2002–2021)",
       x = "Ano", y = "PIB per capita médio (R$)") +
  theme_minimal()

# Evolução do PIB per capita médio do estado
pib_pop_RN |>
  filter(ano == max(ano)) |>
  arrange(desc(pib)) |>
  slice(1:10) |>
  ggplot(aes(x = reorder(nome, pib), y = pib, fill = nome)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(title = "Top 10 municípios por PIB – RN (2021)",
       x = "Município", y = "PIB (R$ mil)") +
  theme_minimal()

# Ranking dos 10 maiores PIB per capita (último ano)
pib_pop_RN |>
  filter(ano == max(ano)) |>
  arrange(desc(pib_per_capita)) |>
  slice(1:10) |>
  ggplot(aes(x = reorder(nome, pib_per_capita), y = pib_per_capita, fill = nome)) +
  geom_col(show.legend = FALSE) +
  coord_flip() +
  scale_y_continuous(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(title = "Top 10 municípios por PIB per capita – RN (2021)",
       x = "Município", y = "PIB per capita (R$)") +
  theme_minimal()

# Taxa de crescimento acumulado (2002–2021)
pib_pop_RN |>
  group_by(nome) |>
  summarise(
    pib_2002 = first(pib),
    pib_2021 = last(pib),
    crescimento_pct = (pib_2021 - pib_2002) / pib_2002 * 100
  ) |>
  arrange(desc(crescimento_pct)) |>
  slice(1:10)

# Relação entre PIB per capita e população
pib_pop_RN |>
  filter(ano == 2021) |>
  ggplot(aes(x = populacao, y = pib_per_capita)) +
  geom_point(alpha = 0.6, color = "#0072B2") +
  scale_x_log10(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  scale_y_log10(labels = label_number(big.mark = ".", decimal.mark = ",")) +
  labs(title = "PIB per capita vs População – Municípios do RN (2021)",
       x = "População (escala log)", y = "PIB per capita (R$)") +
  theme_minimal()

# Desigualdade regional (coeficiente de variação do PIB per capita)
pib_pop_RN |>
  group_by(ano) |>
  summarise(cv_pib_pc = sd(pib_per_capita) / mean(pib_per_capita)) |>
  ggplot(aes(x = ano, y = cv_pib_pc)) +
  geom_line(linewidth = 1.1, color = "#D55E00") +
  labs(title = "Desigualdade de PIB per capita – RN (2002–2021)",
       x = "Ano", y = "Coeficiente de variação") +
  theme_minimal()

# 1 Composição setorial do RN (2002–2021)
pib_pop_RN |>
  mutate(va_total = va_agropecuaria + va_industria + va_servicos + va_adespss) |>
  group_by(ano) |>
  summarise(
    Agropecuária = sum(va_agropecuaria, na.rm = TRUE),
    Indústria    = sum(va_industria,    na.rm = TRUE),
    Serviços     = sum(va_servicos,     na.rm = TRUE),
    Adm_Pública  = sum(va_adespss,      na.rm = TRUE),
    .groups = "drop"
  ) |>
  pivot_longer(-ano, names_to = "setor", values_to = "valor") |>
  group_by(ano) |>
  mutate(perc = valor / sum(valor)) |>
  ggplot(aes(x = ano, y = perc, fill = setor)) +
  geom_area(alpha = .85) +
  scale_y_continuous(labels = label_percent(decimal.mark = ",")) +
  labs(title = "Composição do VA do RN por setor", x = "Ano", y = "Participação no VA") +
  theme_minimal()

# 2 Composição setorial do RN (2002–2021)
pib_pop_RN |>
  filter(ano == max(ano)) |>
  select(nome, va_agropecuaria, va_industria, va_servicos, va_adespss) |>
  pivot_longer(-nome, names_to = "setor", values_to = "valor_mil") |>
  group_by(setor) |>
  summarise(total_reais = sum(valor_mil, na.rm = TRUE)*1/1e6, .groups = "drop") |>
  ggplot(aes(x = setor, y = total_reais, fill = setor)) +
  geom_col() +
  scale_y_continuous(labels = label_dollar(prefix = "R$ ", big.mark = ".", decimal.mark = ",")) +
  labs(
    title = "Composição do PIB do RN por setor econômico",
    x = "Setor",
    y = "Valor adicionado (R$ Bilhões)"
  ) +
  theme_minimal()
