library(sf)
library(dplyr)

# https://es.wikipedia.org/wiki/Áreas_metropolitanas_y_conurbaciones_de_Chile

dat <- lapply(paste0("R",
                     sprintf("%02d", 1:15)),
              function(x) {
                read_sf(
                  paste0(
                    "https://raw.githubusercontent.com/robsalasco/precenso_2016_geojson_chile/master/Limite_Urbano/",
                    x,
                    ".geojson"
                  )
                )
              })

chl <- do.call(rbind, dat)

chl %>% filter(CATEGORIA=="CIUDAD") %>%
  group_by(COMUNA) %>%
  summarize() %>% 
  st_cast("MULTIPOLYGON") %>% mutate(COMUNA=as.numeric(COMUNA)) %>%
  arrange(COMUNA)
