# Parâmetros --------------------------------------------------------------
congl_url <- "http://www.bcb.gov.br/fis/info/cad/conglomerados/"
congl_anos <- 2011:2016
congl_meses <- 1:12

banco_url <- "http://www.bcb.gov.br/fis/info/cad/bancos/"
banco_anos <- 2007:2016
banco_meses <- 1:12

coope_url <- "http://www.bcb.gov.br/fis/info/cad/cooperativas/"
coope_anos <- 2007:2016
coope_meses <- 1:12

socie_url <- "http://www.bcb.gov.br/fis/info/cad/sociedades/"
socie_anos <- 2007:2016
socie_meses <- 1:12

admin_url <- "http://www.bcb.gov.br/fis/info/cad/consorcios/"
admin_anos <- 2007:2016
admin_meses <- 1:12

# Funções Auxiliares ------------------------------------------------------

download <- function(url, anos, meses, dir, nome){
  for (ano in anos) {
    for (mes in meses) {
      download.file(
        url = sprintf("%s%d%02d%s.zip", url, ano, mes, nome), 
        destfile = sprintf("data-raw/zips/%s/%d%02d%s.zip", dir, ano, mes, nome)
      )
      Sys.sleep(0.5)
    }
  }
}

# Download dos dados ------------------------------------------------------

# conglomerados
download(congl_url, congl_anos, congl_meses, "conglomerados", "CONGLOMERADOS")
# bancos
download(banco_url, banco_anos, banco_meses, "bancos", "BANCOS")
# cooperativas
download(coope_url, coope_anos, coope_meses, "cooperativas", "COOPERATIVAS")
# sociedades
download(socie_url, socie_anos, socie_meses, "sociedades", "SOCIEDADES")
# adm/consorcio
download(admin_url, admin_anos, admin_meses, "consorcios", "ADMCONSORCIO")


# Download de um arquivo que possui os códigos de conglomerados -----------

# httr::GET("https://www3.bcb.gov.br/informes/rest/cadastros/conglomerado/", 
#           httr::write_disk("data-raw/cadastro_conglomerados"))

# Existe um arquivo que foi baixado na mão, que está disponível neste link:
# https://www3.bcb.gov.br/informes/rest/cadastros/conglomerado/
