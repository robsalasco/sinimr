library(sf)
library(sinimr)
library(magrittr)
library(mapview)
library(dplyr)
library(leafsync)
fh <- read_sf("/Users/robsalasco/Downloads/AUC-1/AUC2017.shp") %>% 
  filter(CIUDAD=="GRAN SANTIAGO") %>% select(OBJECTID)

st_crs(fh)
fh <- fh %>% st_transform(4326)

ffs <- st_intersects(census_geometry_limites, fh, sparse = FALSE)

(id_geo_census %>% filter(CODE %in% census_geometry_limites[which(as.logical(ffs)), ]$CODE))$MUNICIPALITY

selection <- census_geometry_limites[which(as.logical(ffs)), ]

m1 <- mapview(fh)
m2 <- mapview(selection)

latticeView(m1, m2, ncol = 2, sync = list(c(1, 2)), sync.cursor = FALSE, no.initial.sync = FALSE)

