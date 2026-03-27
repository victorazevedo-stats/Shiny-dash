if (!require(basedosdados)) install.packages("basedosdados"); library(basedosdados)
set_billing_id("projeto59851")

# CAGED ANTIGO ------------------------------------------------------------

# Consulta somente para o RN
query <- "
SELECT
    dados.ano as ano,
    dados.mes as mes,
    dados.sigla_uf AS sigla_uf,
    diretorio_sigla_uf.nome AS sigla_uf_nome,
    dados.id_municipio AS id_municipio,
    diretorio_id_municipio.nome AS id_municipio_nome,
    dados.id_municipio_6 AS id_municipio_6,
    diretorio_id_municipio_6.nome AS id_municipio_6_nome,
    dados.admitidos_desligados as admitidos_desligados,
    dados.tipo_estabelecimento as tipo_estabelecimento,
    dados.tipo_movimentacao_desagregado as tipo_movimentacao_desagregado,
    dados.faixa_emprego_inicio_janeiro as faixa_emprego_inicio_janeiro,
    dados.tempo_emprego as tempo_emprego,
    dados.quantidade_horas_contratadas as quantidade_horas_contratadas,
    dados.salario_mensal as salario_mensal,
    dados.saldo_movimentacao as saldo_movimentacao,
    dados.indicador_aprendiz as indicador_aprendiz,
    dados.indicador_trabalho_intermitente as indicador_trabalho_intermitente,
    dados.indicador_trabalho_parcial as indicador_trabalho_parcial,
    dados.indicador_portador_deficiencia as indicador_portador_deficiencia,
    dados.tipo_deficiencia as tipo_deficiencia,
    dados.cbo_2002 AS cbo_2002,
    diretorio_cbo_2002.descricao AS cbo_2002_descricao,
    diretorio_cbo_2002.descricao_familia AS cbo_2002_descricao_familia,
    diretorio_cbo_2002.descricao_subgrupo AS cbo_2002_descricao_subgrupo,
    diretorio_cbo_2002.descricao_subgrupo_principal AS cbo_2002_descricao_subgrupo_principal,
    diretorio_cbo_2002.descricao_grande_grupo AS cbo_2002_descricao_grande_grupo,
    dados.cnae_1 AS cnae_1,
    diretorio_cnae_1.descricao AS cnae_1_descricao,
    diretorio_cnae_1.descricao_grupo AS cnae_1_descricao_grupo,
    diretorio_cnae_1.descricao_divisao AS cnae_1_descricao_divisao,
    diretorio_cnae_1.descricao_secao AS cnae_1_descricao_secao,
    dados.cnae_2 AS cnae_2,
    diretorio_cnae_2.descricao_subclasse AS cnae_2_descricao_subclasse,
    diretorio_cnae_2.descricao_classe AS cnae_2_descricao_classe,
    diretorio_cnae_2.descricao_grupo AS cnae_2_descricao_grupo,
    diretorio_cnae_2.descricao_divisao AS cnae_2_descricao_divisao,
    diretorio_cnae_2.descricao_secao AS cnae_2_descricao_secao,
    dados.cnae_2_subclasse as cnae_2_subclasse,
    dados.grau_instrucao as grau_instrucao,
    dados.idade as idade,
    dados.sexo as sexo,
    dados.raca_cor as raca_cor,
    dados.subsetor_ibge as subsetor_ibge
FROM `basedosdados.br_me_caged.microdados_antigos` AS dados
LEFT JOIN (SELECT DISTINCT sigla, nome
           FROM `basedosdados.br_bd_diretorios_brasil.uf`) AS diretorio_sigla_uf
       ON dados.sigla_uf = diretorio_sigla_uf.sigla
LEFT JOIN (SELECT DISTINCT id_municipio, nome
           FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio
       ON dados.id_municipio = diretorio_id_municipio.id_municipio
LEFT JOIN (SELECT DISTINCT id_municipio_6, nome
           FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio_6
       ON dados.id_municipio_6 = diretorio_id_municipio_6.id_municipio_6
LEFT JOIN (SELECT DISTINCT cbo_2002, descricao, descricao_familia, descricao_subgrupo,
                          descricao_subgrupo_principal, descricao_grande_grupo
           FROM `basedosdados.br_bd_diretorios_brasil.cbo_2002`) AS diretorio_cbo_2002
       ON dados.cbo_2002 = diretorio_cbo_2002.cbo_2002
LEFT JOIN (SELECT DISTINCT cnae_1, descricao, descricao_grupo, descricao_divisao, descricao_secao
           FROM `basedosdados.br_bd_diretorios_brasil.cnae_1`) AS diretorio_cnae_1
       ON dados.cnae_1 = diretorio_cnae_1.cnae_1
LEFT JOIN (SELECT DISTINCT subclasse, descricao_subclasse, descricao_classe, descricao_grupo,
                          descricao_divisao, descricao_secao
           FROM `basedosdados.br_bd_diretorios_brasil.cnae_2`) AS diretorio_cnae_2
       ON dados.cnae_2 = diretorio_cnae_2.subclasse
WHERE dados.sigla_uf = 'RN'
"
# Carregar direto no R
caged_antigo <- read_sql(query, billing_project_id = get_billing_id())
saveRDS(caged_antigo, "caged.rds")

# CAGED AJUSTE ------------------------------------------------------------

query <- "
SELECT
    dados.ano as ano,
    dados.mes as mes,
    dados.competencia_movimentacao as competencia_movimentacao,
    dados.sigla_uf AS sigla_uf,
    diretorio_sigla_uf.nome AS sigla_uf_nome,
    dados.id_municipio AS id_municipio,
    diretorio_id_municipio.nome AS id_municipio_nome,
    dados.id_municipio_6 AS id_municipio_6,
    diretorio_id_municipio_6.nome AS id_municipio_6_nome,
    dados.admitidos_desligados as admitidos_desligados,
    dados.tipo_estabelecimento as tipo_estabelecimento,
    dados.tipo_movimentacao_desagregado as tipo_movimentacao_desagregado,
    dados.faixa_emprego_inicio_janeiro as faixa_emprego_inicio_janeiro,
    dados.tempo_emprego as tempo_emprego,
    dados.quantidade_horas_contratadas as quantidade_horas_contratadas,
    dados.salario_mensal as salario_mensal,
    dados.saldo_movimentacao as saldo_movimentacao,
    dados.indicador_aprendiz as indicador_aprendiz,
    dados.indicador_trabalho_intermitente as indicador_trabalho_intermitente,
    dados.indicador_trabalho_parcial as indicador_trabalho_parcial,
    dados.indicador_portador_deficiencia as indicador_portador_deficiencia,
    dados.tipo_deficiencia as tipo_deficiencia,
    dados.cbo_1994 AS cbo_1994,
    diretorio_cbo_1994.descricao AS cbo_1994_descricao,
    dados.cbo_2002 AS cbo_2002,
    diretorio_cbo_2002.descricao AS cbo_2002_descricao,
    diretorio_cbo_2002.descricao_familia AS cbo_2002_descricao_familia,
    diretorio_cbo_2002.descricao_subgrupo AS cbo_2002_descricao_subgrupo,
    diretorio_cbo_2002.descricao_subgrupo_principal AS cbo_2002_descricao_subgrupo_principal,
    diretorio_cbo_2002.descricao_grande_grupo AS cbo_2002_descricao_grande_grupo,
    dados.cnae_1 AS cnae_1,
    diretorio_cnae_1.descricao AS cnae_1_descricao,
    diretorio_cnae_1.descricao_grupo AS cnae_1_descricao_grupo,
    diretorio_cnae_1.descricao_divisao AS cnae_1_descricao_divisao,
    diretorio_cnae_1.descricao_secao AS cnae_1_descricao_secao,
    dados.cnae_2_subclasse as cnae_2_subclasse,
    dados.grau_instrucao as grau_instrucao,
    dados.idade as idade,
    dados.sexo as sexo,
    dados.raca_cor as raca_cor,
    dados.subsetor_ibge as subsetor_ibge,
    dados.regiao_metropolitana_mte as regiao_metropolitana_mte
FROM `basedosdados.br_me_caged.microdados_antigos_ajustes` AS dados
LEFT JOIN (SELECT DISTINCT sigla,nome  FROM `basedosdados.br_bd_diretorios_brasil.uf`) AS diretorio_sigla_uf
    ON dados.sigla_uf = diretorio_sigla_uf.sigla
LEFT JOIN (SELECT DISTINCT id_municipio,nome  FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio
    ON dados.id_municipio = diretorio_id_municipio.id_municipio
LEFT JOIN (SELECT DISTINCT id_municipio_6,nome  FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio_6
    ON dados.id_municipio_6 = diretorio_id_municipio_6.id_municipio_6
LEFT JOIN (SELECT DISTINCT cbo_1994,descricao  FROM `basedosdados.br_bd_diretorios_brasil.cbo_1994`) AS diretorio_cbo_1994
    ON dados.cbo_1994 = diretorio_cbo_1994.cbo_1994
LEFT JOIN (SELECT DISTINCT cbo_2002,descricao,descricao_familia,descricao_subgrupo,descricao_subgrupo_principal,descricao_grande_grupo  FROM `basedosdados.br_bd_diretorios_brasil.cbo_2002`) AS diretorio_cbo_2002
    ON dados.cbo_2002 = diretorio_cbo_2002.cbo_2002
LEFT JOIN (SELECT DISTINCT cnae_1,descricao,descricao_grupo,descricao_divisao,descricao_secao  FROM `basedosdados.br_bd_diretorios_brasil.cnae_1`) AS diretorio_cnae_1
    ON dados.cnae_1 = diretorio_cnae_1.cnae_1
WHERE dados.sigla_uf = 'RN'
"

caged_ajuste <- read_sql(query, billing_project_id = get_billing_id())
saveRDS(caged_ajuste, "caged_ajuste.rds")

# NOVO CAGED --------------------------------------------------------------

query <- "
WITH 
dicionario_categoria AS (
    SELECT
        chave AS chave_categoria,
        valor AS descricao_categoria
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'categoria'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_grau_instrucao AS (
    SELECT
        chave AS chave_grau_instrucao,
        valor AS descricao_grau_instrucao
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'grau_instrucao'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_raca_cor AS (
    SELECT
        chave AS chave_raca_cor,
        valor AS descricao_raca_cor
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'raca_cor'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_sexo AS (
    SELECT
        chave AS chave_sexo,
        valor AS descricao_sexo
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'sexo'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_tipo_empregador AS (
    SELECT
        chave AS chave_tipo_empregador,
        valor AS descricao_tipo_empregador
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tipo_empregador'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_tipo_estabelecimento AS (
    SELECT
        chave AS chave_tipo_estabelecimento,
        valor AS descricao_tipo_estabelecimento
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tipo_estabelecimento'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_tipo_movimentacao AS (
    SELECT
        chave AS chave_tipo_movimentacao,
        valor AS descricao_tipo_movimentacao
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tipo_movimentacao'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_tipo_deficiencia AS (
    SELECT
        chave AS chave_tipo_deficiencia,
        valor AS descricao_tipo_deficiencia
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tipo_deficiencia'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_indicador_trabalho_intermitente AS (
    SELECT
        chave AS chave_indicador_trabalho_intermitente,
        valor AS descricao_indicador_trabalho_intermitente
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'indicador_trabalho_intermitente'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_indicador_trabalho_parcial AS (
    SELECT
        chave AS chave_indicador_trabalho_parcial,
        valor AS descricao_indicador_trabalho_parcial
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'indicador_trabalho_parcial'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_indicador_aprendiz AS (
    SELECT
        chave AS chave_indicador_aprendiz,
        valor AS descricao_indicador_aprendiz
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'indicador_aprendiz'
        AND id_tabela = 'microdados_movimentacao'
),
dicionario_origem_informacao AS (
    SELECT
        chave AS chave_origem_informacao,
        valor AS descricao_origem_informacao
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'origem_informacao'
        AND id_tabela = 'microdados_movimentacao'
)
SELECT
    dados.ano as ano,
    dados.mes as mes,
    dados.sigla_uf AS sigla_uf,
    diretorio_sigla_uf.nome AS sigla_uf_nome,
    dados.id_municipio AS id_municipio,
    diretorio_id_municipio.nome AS id_municipio_nome,
    dados.cnae_2_secao as cnae_2_secao,
    dados.cnae_2_subclasse as cnae_2_subclasse,
    dados.saldo_movimentacao as saldo_movimentacao,
    dados.cbo_2002 AS cbo_2002,
    diretorio_cbo_2002.descricao AS cbo_2002_descricao,
    diretorio_cbo_2002.descricao_familia AS cbo_2002_descricao_familia,
    diretorio_cbo_2002.descricao_subgrupo AS cbo_2002_descricao_subgrupo,
    diretorio_cbo_2002.descricao_subgrupo_principal AS cbo_2002_descricao_subgrupo_principal,
    diretorio_cbo_2002.descricao_grande_grupo AS cbo_2002_descricao_grande_grupo,
    descricao_categoria AS categoria,
    descricao_grau_instrucao AS grau_instrucao,
    dados.idade as idade,
    dados.horas_contratuais as horas_contratuais,
    descricao_raca_cor AS raca_cor,
    descricao_sexo AS sexo,
    descricao_tipo_empregador AS tipo_empregador,
    descricao_tipo_estabelecimento AS tipo_estabelecimento,
    descricao_tipo_movimentacao AS tipo_movimentacao,
    descricao_tipo_deficiencia AS tipo_deficiencia,
    descricao_indicador_trabalho_intermitente AS indicador_trabalho_intermitente,
    descricao_indicador_trabalho_parcial AS indicador_trabalho_parcial,
    dados.salario_mensal as salario_mensal,
    dados.tamanho_estabelecimento_janeiro as tamanho_estabelecimento_janeiro,
    descricao_indicador_aprendiz AS indicador_aprendiz,
    descricao_origem_informacao AS origem_informacao,
    dados.indicador_fora_prazo as indicador_fora_prazo
FROM `basedosdados.br_me_caged.microdados_movimentacao` AS dados
LEFT JOIN (SELECT DISTINCT sigla,nome  FROM `basedosdados.br_bd_diretorios_brasil.uf`) AS diretorio_sigla_uf
    ON dados.sigla_uf = diretorio_sigla_uf.sigla
LEFT JOIN (SELECT DISTINCT id_municipio,nome  FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio
    ON dados.id_municipio = diretorio_id_municipio.id_municipio
LEFT JOIN (SELECT DISTINCT cbo_2002,descricao,descricao_familia,descricao_subgrupo,descricao_subgrupo_principal,descricao_grande_grupo  FROM `basedosdados.br_bd_diretorios_brasil.cbo_2002`) AS diretorio_cbo_2002
    ON dados.cbo_2002 = diretorio_cbo_2002.cbo_2002
LEFT JOIN `dicionario_categoria`
    ON dados.categoria = chave_categoria
LEFT JOIN `dicionario_grau_instrucao`
    ON dados.grau_instrucao = chave_grau_instrucao
LEFT JOIN `dicionario_raca_cor`
    ON dados.raca_cor = chave_raca_cor
LEFT JOIN `dicionario_sexo`
    ON dados.sexo = chave_sexo
LEFT JOIN `dicionario_tipo_empregador`
    ON dados.tipo_empregador = chave_tipo_empregador
LEFT JOIN `dicionario_tipo_estabelecimento`
    ON dados.tipo_estabelecimento = chave_tipo_estabelecimento
LEFT JOIN `dicionario_tipo_movimentacao`
    ON dados.tipo_movimentacao = chave_tipo_movimentacao
LEFT JOIN `dicionario_tipo_deficiencia`
    ON dados.tipo_deficiencia = chave_tipo_deficiencia
LEFT JOIN `dicionario_indicador_trabalho_intermitente`
    ON dados.indicador_trabalho_intermitente = chave_indicador_trabalho_intermitente
LEFT JOIN `dicionario_indicador_trabalho_parcial`
    ON dados.indicador_trabalho_parcial = chave_indicador_trabalho_parcial
LEFT JOIN `dicionario_indicador_aprendiz`
    ON dados.indicador_aprendiz = chave_indicador_aprendiz
LEFT JOIN `dicionario_origem_informacao`
    ON dados.origem_informacao = chave_origem_informacao
WHERE dados.sigla_uf = 'RN'
"

novo_caged <- read_sql(query, billing_project_id = get_billing_id())
saveRDS(novo_caged, "novo_caged.rds")

# NOVO CAGED FORA DE PRAZO ------------------------------------------------

query <- "
WITH 
dicionario_grau_instrucao AS (
    SELECT
        chave AS chave_grau_instrucao,
        valor AS descricao_grau_instrucao
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'grau_instrucao'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_raca_cor AS (
    SELECT
        chave AS chave_raca_cor,
        valor AS descricao_raca_cor
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'raca_cor'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_sexo AS (
    SELECT
        chave AS chave_sexo,
        valor AS descricao_sexo
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'sexo'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_tipo_empregador AS (
    SELECT
        chave AS chave_tipo_empregador,
        valor AS descricao_tipo_empregador
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tipo_empregador'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_tipo_estabelecimento AS (
    SELECT
        chave AS chave_tipo_estabelecimento,
        valor AS descricao_tipo_estabelecimento
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tipo_estabelecimento'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_tipo_movimentacao AS (
    SELECT
        chave AS chave_tipo_movimentacao,
        valor AS descricao_tipo_movimentacao
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tipo_movimentacao'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_tipo_deficiencia AS (
    SELECT
        chave AS chave_tipo_deficiencia,
        valor AS descricao_tipo_deficiencia
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tipo_deficiencia'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_indicador_trabalho_intermitente AS (
    SELECT
        chave AS chave_indicador_trabalho_intermitente,
        valor AS descricao_indicador_trabalho_intermitente
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'indicador_trabalho_intermitente'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_indicador_trabalho_parcial AS (
    SELECT
        chave AS chave_indicador_trabalho_parcial,
        valor AS descricao_indicador_trabalho_parcial
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'indicador_trabalho_parcial'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_tamanho_estabelecimento_janeiro AS (
    SELECT
        chave AS chave_tamanho_estabelecimento_janeiro,
        valor AS descricao_tamanho_estabelecimento_janeiro
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'tamanho_estabelecimento_janeiro'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_indicador_aprendiz AS (
    SELECT
        chave AS chave_indicador_aprendiz,
        valor AS descricao_indicador_aprendiz
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'indicador_aprendiz'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_origem_informacao AS (
    SELECT
        chave AS chave_origem_informacao,
        valor AS descricao_origem_informacao
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'origem_informacao'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
),
dicionario_categoria AS (
    SELECT
        chave AS chave_categoria,
        valor AS descricao_categoria
    FROM `basedosdados.br_me_caged.dicionario`
    WHERE
        TRUE
        AND nome_coluna = 'categoria'
        AND id_tabela = 'microdados_movimentacao_fora_prazo'
)
SELECT
    dados.ano as ano,
    dados.mes as mes,
    dados.ano_competencia_movimentacao as ano_competencia_movimentacao,
    dados.mes_competencia_movimentacao as mes_competencia_movimentacao,
    dados.sigla_uf AS sigla_uf,
    diretorio_sigla_uf.nome AS sigla_uf_nome,
    dados.id_municipio AS id_municipio,
    diretorio_id_municipio.nome AS id_municipio_nome,
    dados.cnae_2_secao as cnae_2_secao,
    dados.cnae_2_subclasse as cnae_2_subclasse,
    dados.saldo_movimentacao as saldo_movimentacao,
    dados.cbo_2002 AS cbo_2002,
    diretorio_cbo_2002.descricao AS cbo_2002_descricao,
    diretorio_cbo_2002.descricao_familia AS cbo_2002_descricao_familia,
    diretorio_cbo_2002.descricao_subgrupo AS cbo_2002_descricao_subgrupo,
    diretorio_cbo_2002.descricao_subgrupo_principal AS cbo_2002_descricao_subgrupo_principal,
    diretorio_cbo_2002.descricao_grande_grupo AS cbo_2002_descricao_grande_grupo,
    descricao_grau_instrucao AS grau_instrucao,
    dados.idade as idade,
    dados.horas_contratuais as horas_contratuais,
    descricao_raca_cor AS raca_cor,
    descricao_sexo AS sexo,
    descricao_tipo_empregador AS tipo_empregador,
    descricao_tipo_estabelecimento AS tipo_estabelecimento,
    descricao_tipo_movimentacao AS tipo_movimentacao,
    descricao_tipo_deficiencia AS tipo_deficiencia,
    descricao_indicador_trabalho_intermitente AS indicador_trabalho_intermitente,
    descricao_indicador_trabalho_parcial AS indicador_trabalho_parcial,
    dados.salario_mensal as salario_mensal,
    descricao_tamanho_estabelecimento_janeiro AS tamanho_estabelecimento_janeiro,
    descricao_indicador_aprendiz AS indicador_aprendiz,
    descricao_origem_informacao AS origem_informacao,
    dados.indicador_fora_prazo as indicador_fora_prazo,
    descricao_categoria AS categoria
FROM `basedosdados.br_me_caged.microdados_movimentacao_fora_prazo` AS dados
LEFT JOIN (SELECT DISTINCT sigla,nome  FROM `basedosdados.br_bd_diretorios_brasil.uf`) AS diretorio_sigla_uf
    ON dados.sigla_uf = diretorio_sigla_uf.sigla
LEFT JOIN (SELECT DISTINCT id_municipio,nome  FROM `basedosdados.br_bd_diretorios_brasil.municipio`) AS diretorio_id_municipio
    ON dados.id_municipio = diretorio_id_municipio.id_municipio
LEFT JOIN (SELECT DISTINCT cbo_2002,descricao,descricao_familia,descricao_subgrupo,descricao_subgrupo_principal,descricao_grande_grupo  FROM `basedosdados.br_bd_diretorios_brasil.cbo_2002`) AS diretorio_cbo_2002
    ON dados.cbo_2002 = diretorio_cbo_2002.cbo_2002
LEFT JOIN `dicionario_grau_instrucao`
    ON dados.grau_instrucao = chave_grau_instrucao
LEFT JOIN `dicionario_raca_cor`
    ON dados.raca_cor = chave_raca_cor
LEFT JOIN `dicionario_sexo`
    ON dados.sexo = chave_sexo
LEFT JOIN `dicionario_tipo_empregador`
    ON dados.tipo_empregador = chave_tipo_empregador
LEFT JOIN `dicionario_tipo_estabelecimento`
    ON dados.tipo_estabelecimento = chave_tipo_estabelecimento
LEFT JOIN `dicionario_tipo_movimentacao`
    ON dados.tipo_movimentacao = chave_tipo_movimentacao
LEFT JOIN `dicionario_tipo_deficiencia`
    ON dados.tipo_deficiencia = chave_tipo_deficiencia
LEFT JOIN `dicionario_indicador_trabalho_intermitente`
    ON dados.indicador_trabalho_intermitente = chave_indicador_trabalho_intermitente
LEFT JOIN `dicionario_indicador_trabalho_parcial`
    ON dados.indicador_trabalho_parcial = chave_indicador_trabalho_parcial
LEFT JOIN `dicionario_tamanho_estabelecimento_janeiro`
    ON dados.tamanho_estabelecimento_janeiro = chave_tamanho_estabelecimento_janeiro
LEFT JOIN `dicionario_indicador_aprendiz`
    ON dados.indicador_aprendiz = chave_indicador_aprendiz
LEFT JOIN `dicionario_origem_informacao`
    ON dados.origem_informacao = chave_origem_informacao
LEFT JOIN `dicionario_categoria`
    ON dados.categoria = chave_categoria
WHERE dados.sigla_uf = 'RN'
"

novo_caged_fp<-read_sql(query, billing_project_id = get_billing_id())
saveRDS(novo_caged_fp, "novo_caged_fp.rds")
