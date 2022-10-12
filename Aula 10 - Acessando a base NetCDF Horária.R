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

nc_data <-
  ncdf4::nc_open("dados_netcdf_2018_2020_baixados.nc") 

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
  round(.,2) # 25 pontos de grade

# Obtendo a latitude
nc_lat <-
  nc_data$dim$latitude$vals %>% 
  round(.,2) # 16 pontos de grade

# Obtendo a dimensão de datas
nc_time <-
  ncvar_get(
    nc_data,
    'time')

nc_time <- 
  as_datetime(c(nc_time * 3600) , origin = '1900-01-01')

# Iniciando a transformação

malha <-
  expand.grid(
    long = nc_long,
    lat = nc_lat
  ) %>% data.frame()

# Criando a tabela de índices

for (i in 1:nrow(malha)){
  
  malha$pos_long[i] <-
    which(
      malha$long[i] == nc_long
    )
  
  malha$pos_lat[i] <-
    which(
      malha$lat[i] == nc_lat
    )
  
}

# Criando um dataframe

df <- 
  data.frame()

for (i in 1:nrow(malha)){
  
  df <-
    
    rbind(df,
    
      data.frame(
        long = malha$long[i],
        lat = malha$lat[i],
        periodo = format(nc_time),
        temperatura = 
          nc_temperature[
            malha$pos_long[i],
            malha$pos_lat[i],
          ],
        precipitacao = 
          nc_precipitation[
            malha$pos_long[i],
            malha$pos_lat[i],
          ]
      )
    
    )
  
  print(i)
  
}

# Conversão de variáveis

df %>%
  mutate(
    temperatura = temperatura - 273.15,
    precipitacao = precipitacao * 1000
  ) %>% write.csv2(.,'dataframe_horario_ajustado.csv')



rm(malha, nc_data, i, nc_lat, nc_long, nc_precipitation, nc_temperature, nc_time)






