# Script de funções que calcularão os índices

sapply(
  list(
    'tidyverse',
    'ncdf4',
    'lubridate',
    'data.table'
  ),
  library,
  character.only = T
)

# RX1Day: Máxima precipitação "anual" de um dia

rx1day <- function(precipitacao){
    
    return(max(precipitacao))
    
}

# Exemplo!
sample(100,size = 365, replace = T) %>% max()

# RX5Day: Máxima precipitação "anual" de cinco dias

rx5day <- function(precipitacao){
  
  return(
    max(
      frollsum(precipitacao,5),na.rm = T
    )
  )
  
}

# Exemplo!
data.frame(
  a = 1:20
) %>%
  mutate(
    b = frollsum(a,5,na.rm = T)
  ) %>% View()


# CDD: Número máximo de dias consecutivos secos (PPT < 1mm)

cdd <- function(precipitacao){
  
  seq <- c()
  
  val_sum <- 0
  
  for (i in precipitacao){
   
   if (i < 1){
     
     val_sum <- val_sum + 1
    
   }
    else{
      
      val_sum <- 0
      
    }
  
   seq <- append(seq,val_sum)
    
    
  }
  
  return(
    
    max(seq)
    
    )

}

# Exemplo!
c(1,4,3,2,0.6,0.9,0.65,1,5,6,4,6,54,0.2,0.5,0.7,8,0.4,0.1,0.4,0.85) %>% cdd()

# CWD: Número máximo consecutivo de dias úmidos (PPT > 1mm)

cwd <- function(precipitacao){
  
  seq <- c()
  
  val_sum <- 0
  
  for (i in precipitacao){
    
    if (i > 1){
      
      val_sum <- val_sum + 1
      
    }
    else{
      
      val_sum <- 0
      
    }
    
  seq <- append(seq,val_sum)
    
  }
  
  return(
    
    max(seq)
    
  )
  
}

# Exemplo!
c(1,4,3,2,0.5,0.6,0.9,0.65,4,5,6,54,0.2) %>% cwd()

# PRCPTOT: Precipitação total anual

prcptot <- function(precipitacao){
  
  return(
    sum(
      precipitacao,na.rm = T
    )
  )
  
}


# Carregando o dado

df <- read.csv2('dataframe_diario_ajustado.csv',
                header = T, 
                sep = ';',
                colClasses = 
                  c(
                    long = 'factor',
                    lat = 'factor',
                    periodo = 'Date'
                  ))


# Testando as funções

climate_indexes <-
  df %>%
    group_by(
      long,
      lat,
      ano = year(periodo)
    ) %>%
    summarise(
      rx1day = rx1day(precipitacao),
      rx5day = rx5day(precipitacao),
      cdd = cdd(precipitacao),
      cwd = cwd(precipitacao),
      prcptot = prcptot(precipitacao)
    )

climate_indexes %>% View()

climate_indexes %>% 
  write.csv2(.,'climate_indexes_calculated_PART1.csv')

