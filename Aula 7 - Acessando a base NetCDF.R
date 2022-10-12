# Pacotes que utilizaremos

sapply(
  list(
    'tidyverse',
    'ncdf4',
    'lubridate'
  ),
  library,
  character.only = T
)

# Carregando o conjunto

setwd(
  'C:/Users/vinip/OneDrive/Área de Trabalho/Vinicius-Possato-Rosse/Udemy-Instrutor/Manipulação de dados meteorológicos/Planejamento/Conjunto-ERA5/dados_mensais'
)

nc_data <-
  ncdf4::nc_open("dados_netcdf_2015_2020_baixados.nc") 

# Examinando os dados

nc_temperature <- ncdf4::ncvar_get(
  nc_data,
  't2m')

nc_precipitation <- ncdf4::ncvar_get(
  nc_data,
  'tp')

nc_long <- 
  nc_data$dim$longitude$vals %>% 
  round(.,2) %>% as.vector() # 51 pontos de grade

nc_lat <-
  nc_data$dim$latitude$vals %>% 
  round(.,2) %>% as.vector() # 40 pontos de grade

nc_months <-
  seq.Date(
    as.Date('2015-01-01'),
    as.Date('2020-12-01'),
    '1 month'
  )

# 1° Passo: Criando a malha de latitudes e de longitudes

malha <- 
  expand.grid(
    long = nc_long,
    lat = nc_lat) 

# 2° Obtendo as posições de cada longitude e latitude

for (i in 1:nrow(malha)){
  
  malha$pos_long[i] <-
    which(malha$long[i] == nc_long)
  
  malha$pos_lat[i] <-
    which(malha$lat[i] == nc_lat)
}

# 3° Criando um dataframe com as séries de temperatura e de precipitação

df <- data.frame()

for (i in 1:nrow(malha)){

  df <- 
    rbind(
      data.frame(
        # Dados gerais
        long = malha$long[i],
        lat = malha$lat[i],
        periodo = nc_months,
        # Varivéis convertidas
        temperatura = nc_temperature[
          malha$pos_long[i],
          malha$pos_lat[i],
          ] - 273.15,
        precipitacao = nc_precipitation[
          malha$pos_long[i],
          malha$pos_lat[i],
        ] * 1000 * days_in_month(nc_months) 
      ),
        df)
}


df %>%
  write.csv2(.,'dataframe-ajustado.csv')

# Encerrando o script
rm(
  nc_long,
  nc_lat,
  nc_months,
  nc_precipitation,
  nc_temperature,
  malha,
  nc_data
)



  
