# Pacotes -----------------------------------------------------------------
library(plyr)

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

