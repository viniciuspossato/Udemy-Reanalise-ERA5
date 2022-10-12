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

nc_data # t2m: variável de temperatura ; tp: total precipitation

# Obtendo a temperatura
nc_temperature <- ncdf4::ncvar_get(
  nc_data,
  't2m')

# Obtendo a precipitação
nc_precipitation <- ncdf4::ncvar_get(
  nc_data,
  'tp')

# Obtendo as longitudes
nc_long <- 
  nc_data$dim$longitude$vals %>% 
  round(.,2) # 51 pontos de grade

# Obtendo a latitude
nc_lat <-
  nc_data$dim$latitude$vals %>% 
  round(.,2) # 40 pontos de grade

# Obtendo a dimensão de datas
nc_months <-
  seq.Date(
    as.Date('2015-01-01'),
    as.Date('2020-12-01'),
    '1 month'
  )

## Manipulando o conjunto:
## Para a lat -13.93 e long -43.66, obtenha a série de precipitação e de temperatura

# Precipitação (m)

which(nc_lat == -13.93) # 1

which(nc_long == -43.66) # 34

nc_months # Encontre a posição dos dados

nc_precipitation[34,1,] # longitude | latitude | time

# Temperatura (K)

which(nc_lat == -13.93) # 1

which(nc_long == -43.66) # 34

nc_months # Encontre a posição dos dados

nc_temperature[34,1,] # longitude | latitude | time

# Caso quiséssemos, portanto, obter toda a série de dados para dez/2019, deveríamos:

which(nc_months == "2019-12-01") # 60

nc_precipitation[,,60]

nc_temperature[,,60]

# Vamos agora plotar o gráfico com os dados que possuímos

filled.contour(
  nc_temperature[,,60],
  plot.title = "Gráfico de temperatura"
    )

filled.contour(
  nc_precipitation[,,60],
  plot.title = "Gráfico de Precipitação"
)
