# Pacotes -----------------------------------------------------------------
library(dplyr)
library(jsonlite)
library(tidyr)

# Leitura das bases -------------------------------------------------------

base_congl <- read.csv("data/base_conglomerados.csv", stringsAsFactors = F)
base_banco <- read.csv("data/base_bancos.csv", stringsAsFactors = F)
base_socie <- read.csv("data/base_sociedades.csv", stringsAsFactors = F)
base_conso <- read.csv("data/base_consorcios.csv", stringsAsFactors = F)
base_coope <- read.csv("data/base_cooperativas.csv", stringsAsFactors = F)

# Tratamentos -------------------------------------------------------------

# base conglomerados
base_congl_1 <- base_congl %>%
  mutate(CNPJ = as.numeric(CNPJ)) %>%
  select(CNPJ, 
         NOME_CONGLOMERADO,
         NOME_INSTITUICAO = NOME_INSTITUIÇÃO_PARTICIPANTE,
         TIPO_PARTICIPACAO = TIPO_PARTICIPAÇÃO_,
         tipo
         ) %>%
  filter(!duplicated(CNPJ))

# base dos bancos
base_banco_1 <- base_banco %>%
  mutate(
    CNPJ = as.numeric(CNPJ),
    NOME_INSTITUICAO = ifelse(is.na(NOME_INSTITUIÇÃO), NOME_DA_INSTITUIÇÃO, NOME_INSTITUIÇÃO)
    ) %>%
  select(
    CNPJ,
    NOME_INSTITUICAO,
    tipo
    ) %>%
  filter(!duplicated(CNPJ))

# base sociedades
base_socie_1 <- base_socie %>%
  mutate(
    NOME_INSTITUICAO = ifelse(is.na(NOME_INSTITUIÇÃO), NOME_DA_INSTITUIÇÃO, NOME_INSTITUIÇÃO),
    NOME_INSTITUICAO = ifelse(is.na(NOME_INSTITUICAO), NOME, NOME_INSTITUICAO)
  ) %>%
  select(
    CNPJ,
    NOME_INSTITUICAO,
    tipo
  ) %>%
  filter(!duplicated(CNPJ))

# bases consorcio
base_conso_1 <- base_conso %>%
  mutate(
    NOME_INSTITUICAO = ifelse(is.na(NOME_INSTITUIÇÃO), NOMEINSTITUIÇÃO, NOME_INSTITUIÇÃO)
  ) %>%
  select(
    CNPJ,
    NOME_INSTITUICAO,
    tipo
  ) %>%
  filter(!duplicated(CNPJ))

# base cooperativas

base_coope_1 <- base_coope %>%
  mutate(
    NOME_INSTITUICAO = ifelse(is.na(NOME_INSTITUIÇÃO), NOME_DA_INSTITUIÇÃO, NOME_INSTITUIÇÃO)
  ) %>%
  select(
    CNPJ,
    NOME_INSTITUICAO,
    tipo
  ) %>%
  filter(!duplicated(CNPJ))

# Cadastro conglomerados --------------------------------------------------

cadastro_cong <- fromJSON("data-raw/cadastro_conglomerados.json")
cadastro_cong <- rename(cadastro_cong, nome_conglom = nome)
cadastro_cong <- cadastro_cong %>% unnest(participacoes)


# Juntar todas as bases ---------------------------------------------------

base_instituicoes <- bind_rows(base_congl_1, base_banco_1, base_conso_1, base_socie_1, base_coope_1)
base_instituicoes$CNPJ <- as.integer(base_instituicoes$CNPJ)
base_instituicoes$NOME_CONGLOMERADO <- str_trim(base_instituicoes$NOME_CONGLOMERADO)
base_instituicoes <- base_instituicoes %>% filter(!duplicated(CNPJ))

base_instituicoes <- base_instituicoes %>% 
  left_join(cadastro_cong %>% select(nome_conglom, codigo), by = c("NOME_CONGLOMERADO" = "nome_conglom"))


# Salvar a base -----------------------------------------------------------

write.csv(base_instituicoes, file = "data/base_instituicoes.csv", row.names = F)


