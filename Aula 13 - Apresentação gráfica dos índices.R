# Criando gráficos para analisar os índices climáticos

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
  read.csv2('climate_indexes_calculated_PART1.csv',
            sep = ';',
            header = T,
            colClasses = 
              c(
                ano = 'factor'
              )
  )

df <- 
  df %>%
  mutate(
    long = as.numeric(long),
    lat = as.numeric(lat)
  )

# Obtendo a malha geográfica

sc <-
  geobr::read_state(code_state = 42 ,simplified = T)

# Gráfico CDD

df %>% 
  ggplot(.) +
  geom_raster(
    aes(x = long,
        y = lat,
        fill = cdd),
    interpolate = T
  ) +
  geom_sf(data = sc, fill = NA, col = 'white') +
  scale_fill_viridis_c(direction = -1) +
  theme_test() +
  labs(
    x = 'Longitude',
    y = 'Latitude',
    title = 'CDD - Santa Catarina',
    subtitle = 'SC 2018 - 2020',
    fill = 'CDD (Dias)'
  ) +
  scale_x_continuous(breaks = seq(-53.5,-43,1.5)) +
  scale_y_continuous(breaks = seq(-30,-25.5,1.5)) +
  facet_wrap(~ano,ncol = 2)

# Gráfico CWD

df %>% 
  ggplot(.) +
  geom_raster(
    aes(x = long,
        y = lat,
        fill = cwd),
    interpolate = T
  ) +
  geom_sf(data = sc, fill = NA, col = 'white') +
  scale_fill_viridis_c(direction = -1) +
  theme_test() +
  labs(
    x = 'Longitude',
    y = 'Latitude',
    title = 'CWD - Santa Catarina',
    subtitle = 'SC 2018 - 2020',
    fill = 'CWD (Dias)'
  ) +
  scale_x_continuous(breaks = seq(-53.5,-43,1.5)) +
  scale_y_continuous(breaks = seq(-30,-25.5,1.5)) +
  facet_wrap(~ano,ncol = 2)


