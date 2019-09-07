library(sinimr)
library(tmap)
library(dplyr)

comunas.names <- c("CERRILLOS", "LA REINA", "PUDAHUEL", "CERRO NAVIA", "LAS CONDES",
                  "QUILICURA", "CONCHALÍ", "LO BARNECHEA", "QUINTA NORMAL", "EL BOSQUE",
                  "LO ESPEJO", "RECOLETA", "ESTACIÓN CENTRAL", "LO PRADO", "RENCA", "HUECHURABA",
                  "MACUL", "SAN MIGUEL", "INDEPENDENCIA", "MAIPÚ", "SAN JOAQUÍN", "LA CISTERNA", "ÑUÑOA",
                  "SAN RAMÓN", "LA FLORIDA", "PEDRO AGUIRRE CERDA", "SANTIAGO", "LA PINTANA", "PEÑALOLÉN",
                  "VITACURA", "LA GRANJA", "PROVIDENCIA", "SAN BERNARDO", "PUENTE ALTO", "PADRE HURTADO", "PIRQUE",
                  "SAN JOSÉ DE MAIPO")

comunas.codes<- filter(id_geo_census, MUNICIPALITY %in% comunas.names) %>% pull(CODE)

# Variable code
var <- 880
# Variable year
year <- 2018
# Getting data and plotting
tm <- get_sinim(var, year, geometry = T, region=5, truevalue = T, unit = "limites") %>%
  filter(!(CODE %in% c(5201,5104))) %>% 
  tm_shape() +
  tm_fill(col = "VALUE", 
          title=get_sinim_var_name(var),
          palette = "PuRd", 
          border.col = "white", 
          style = "pretty")+
  tm_text("MUNICIPALITY", size = 0.4) +
  tm_layout(legend.format = list(text.separator = "a", fun = mm), 
            legend.outside=F, outer.margins = c(0.05,0.10,0.05,0.10),
            inner.margins = c(0.01,0.1,0.08,0.01)) +
  tm_grid(labels.inside.frame = F, col = "#d3d3d3", alpha = 0.25, labels.size = 0.8, n.x=7, n.y=7) +
  tm_borders(col = 'black')+
  tm_compass(position=c("left", "top")) +
  tm_scale_bar(position = c("left","bottom"))
  
tmap_save(tm, "map.png", width = 10, height = 10, units = "in")
