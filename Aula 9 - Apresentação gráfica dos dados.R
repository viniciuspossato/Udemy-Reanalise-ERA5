# Carregando os pacotes

sapply(
  list(
    'tidyverse',
    'ncdf4',
    'lubridate',
    'geobr',
    'glue'
  ),
  library,
  character.only = T
)

# Carregando a base

df <- 
  read.csv2('dataframe-variaveis-ajustadas.csv',
            sep = ';',
            header = T,
            colClasses = 
              c(
                periodo = 'POSIXct',
                trimestre = 'factor',
                semestre = 'factor',
                ano = 'factor',
                estacao_ano = 'factor')
              )

# Removando as colunas de índice, que não serão utilizadas

df <-
  df[,-c(1:2)]


# Obtendo a malha de dados de MG

mg <-
  geobr::read_state(31,simplified = T) # 31 é o código de MG

ggplot() + 
  geom_sf(
    data = mg)

# Gráfico de precipitação total por ano de dado

df %>% 
  group_by(
    long,
    lat,
    ano
  ) %>%
  summarise(
    tot_precip = sum(precipitacao, na.rm = T)
  ) %>% View()


df %>% 
  group_by(
    long,
    lat,
    ano
  ) %>%
  summarise(
    tot_precip = sum(precipitacao, na.rm = T)
  ) %>% 
  ggplot(.) +
  geom_raster(
    aes(x = long,
        y = lat,
        fill = tot_precip),
        interpolate = T
  ) +
  geom_sf(data = mg, fill = NA, col = 'white') +
  scale_fill_viridis_c(direction = -1) +
  theme_test() +
  labs(
    x = 'Longitude',
    y = 'Latitude',
    title = 'Precipitação Total Acumulado',
    subtitle = 'MG 2015 - 2020',
    fill = 'Precipitação Total (mm)'
  ) +
  scale_x_continuous(breaks = seq(-52,-39,4)) +
  scale_y_continuous(breaks = seq(-24,-13,4)) +
  facet_wrap(~ano)

# Temperatura média por ano

df %>% 
  group_by(
    long,
    lat,
    ano
  ) %>%
  summarise(
    temperatura_media = mean(temperatura, na.rm = T)
  ) %>% View()

df %>% 
  group_by(
    long,
    lat,
    ano
  ) %>%
  summarise(
    temperatura_media = mean(temperatura, na.rm = T)
  ) %>% 
  ggplot(.) +
  geom_raster(
    aes(x = long,
        y = lat,
        fill = temperatura_media),
    interpolate = T
  ) +
  geom_sf(data = mg, fill = NA, col = 'white') +
  scale_fill_viridis_c(direction = -1) +
  theme_test() +
  labs(
    x = 'Longitude',
    y = 'Latitude',
    title = 'Temperatura média anual(°C)',
    subtitle = 'MG 2015 - 2020',
    fill = 'Temperatura média (°C)'
  ) +
  scale_x_continuous(breaks = seq(-52,-39,4)) +
  scale_y_continuous(breaks = seq(-24,-13,4)) +
  facet_wrap(~ano)

## Analisando a temperatura por "estação" DJF

df %>% 
  filter(
    estacao_ano == "DJF"
  ) %>% 
  group_by(
    long,
    lat,
    ano
  ) %>%
  summarise(
    temperatura_media = 
      mean(temperatura, 
           na.rm = T) 
  ) %>% View()

df %>% 
  filter(
    estacao_ano == "DJF"
  ) %>%
  group_by(
    long,
    lat,
    ano
  ) %>%
  summarise(
    temperatura_media = 
      mean(temperatura, 
           na.rm = T) 
  ) %>%
  ggplot(.) +
  geom_raster(
    aes(x = long,
        y = lat,
        fill = temperatura_media),
    interpolate = T
  ) +
  geom_sf(data = mg, fill = NA, col = 'white') +
  scale_fill_viridis_c(direction = -1) +
  theme_test() +
  labs(
    x = 'Longitude',
    y = 'Latitude',
    title = 'Temperatura média DJF por Ano (°C)',
    subtitle = 'MG 2015 - 2020',
    fill = 'Temperatura média (°C)'
  ) +
  scale_x_continuous(breaks = seq(-52,-39,4)) +
  scale_y_continuous(breaks = seq(-24,-13,4)) +
  facet_wrap(~ano)


## Analisando a temperatura por "estação" JJA

df %>% 
  filter(
    estacao_ano == "JJA"
  ) %>%
  group_by(
    long,
    lat,
    ano
  ) %>%
  summarise(
    temperatura_media = 
      mean(temperatura, 
           na.rm = T)
  ) %>%
  ggplot(.) +
  geom_raster(
    aes(x = long,
        y = lat,
        fill = temperatura_media),
    interpolate = T
  ) +
  geom_sf(data = mg, fill = NA, col = 'white') +
  scale_fill_viridis_c(direction = -1) +
  theme_test() +
  labs(
    x = 'Longitude',
    y = 'Latitude',
    title = 'Temperatura média JJA por Ano (°C)',
    subtitle = 'MG 2015 - 2020',
    fill = 'Temperatura média (°C)'
  ) +
  scale_x_continuous(breaks = seq(-52,-39,4)) +
  scale_y_continuous(breaks = seq(-24,-13,4)) +
  facet_wrap(~ano)

