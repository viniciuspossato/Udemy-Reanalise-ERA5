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

df <-
  read.csv2('dataframe_horario_ajustado.csv', 
            header = T,
            sep = ';',
              ) # Os dados são grandes, portanto, podem ser demorados!

# Transformação dos dados horários em diários

df <-
  df %>%
    mutate(
      long = as.factor(long),
      lat = as.factor(lat),
      periodo = as.Date(periodo),
      precipitacao = ifelse(precipitacao < 0, 0, precipitacao)
    ) %>% 
    group_by(
      long,
      lat,
      periodo
    ) %>%
    summarise(
      precipitacao = sum(precipitacao),
      temperatura = mean(temperatura)
    )

# Salvando o conjunto diário criado

df %>% 
  write.csv2(.,'dataframe_diario_ajustado.csv')
