# Pacotes -----------------------------------------------------------------
library(plyr)
library(readxl)
library(stringr)
library(dplyr)

# Deszipar ----------------------------------------------------------------
diretorios <- c("bancos", "conglomerados", "consorcios", "cooperativas", "sociedades")
dir <- diretorios[1]
l_ply(diretorios, function(dir){
  arqs <- list.files(sprintf("data-raw/zips/%s/", dir))
  l_ply(arqs, function(arq){
    unzip(
      zipfile = sprintf("data-raw/zips/%s/%s", dir, arq), 
      exdir = sprintf("data-raw/unzips/%s/", dir)
      )
  })
}, .progress = "text")

# Funções Auxiliares ------------------------------------------------------

achar_primeira_completa <- function(base){
  line <- 1
  while(line <= nrow(base)){
    linha <- as.character(base[line, ])
    qtdNA <- sum(is.na(linha))
    if(qtdNA == 0){
      qtd_caract <- linha %>% str_replace_all("[:space:]", "") %>%
                           str_length()
      if(sum(qtd_caract == 0) > 0){
       line <- line + 1 
      } else {
        return(line) 
      }
    } else{
      line <- line + 1
    }
  }
  return(1)
}
arrumar_base <- function(base){
  # retirar coluna que só tem NA
  qtdNA <- laply(base, function(x) sum(!is.na(x)))
  if(sum(qtdNA == 0) > 0){
    base <- base[,qtdNA > 0]
  }
  # determinar linha que começa
  linha <- achar_primeira_completa(base)
  names(base) <- as.character(base[linha, ]) %>% str_replace_all("[:space:]", "_")
  base <- base[-c(1:linha),]
  return(base)
}

# Juntar as bases ---------------------------------------------------------

# processar a base de conglomerados
diretorios <- c("bancos", "conglomerados", "consorcios", "cooperativas", "sociedades")
names(diretorios) <- diretorios
bases <- llply(diretorios, function(dir){
  arqs <- list.files(sprintf("data-raw/unzips/%s/", dir))
  arqs <- arqs[!str_detect(arqs, fixed(".zip"))]
  bases <- ldply(arqs, function(arq){
    b <- read_excel(sprintf("data-raw/unzips/%s/%s", dir, arq))
    b <- arrumar_base(b)
    b$ano <- str_sub(arq, 1, 4)
    b$mes <- str_sub(arq, 5, 6)
    b$tipo <- dir
    b
  })
}, .progress = "text")

bases <- llply(bases, function(base){
  base %>%
    filter(!is.na(CNPJ), (str_sub(CNPJ,1,1) %>% str_detect("[0-9]")))
})

for (nome in names(bases)) {
  write.csv(bases[[nome]], sprintf("data/base_%s.csv", nome), row.names = F)
}




