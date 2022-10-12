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

# Carregando a base de dados

df <-
  read.csv2('dataframe-ajustado.csv', 
            header = T,
            sep = ';',
            colClasses = 
              c(
                x = 'numeric',
                long = 'character',
                lat = 'character',
                periodo = 'POSIXct',
                temperatura = 'numeric',
                precipitacao = 'numeric'
              ))
  
# Criando novas variáveis no conjunto ajustado

df <- 
  df %>%
    mutate(
      trimestre = quarter(periodo),
      semestre = lubridate::semester(periodo),
      ano = year(periodo),
      estacao_ano = 
        case_when(
          month(periodo) %in% c(12,1,2) ~ 'DJF', # Verão
          month(periodo) %in% c(3,4,5) ~ 'MAM', # Outono
          month(periodo) %in% c(6,7,8) ~ 'JJA', # Inverno
          month(periodo) %in% c(9,10,11) ~ 'SON', # Primavera
        )
    ) 

df %>%
  View()

# Salvando os dados

df %>%
  write.csv2(.,'dataframe-variaveis-ajustadas.csv')

# Limpando o ambiente

rm(list = ls())
