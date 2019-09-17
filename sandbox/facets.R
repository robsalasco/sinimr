tm <- get_sinim(var, year, geometry = T, truevalue = T, idgeo = T, unit = "comunas") %>%
  filter(!(CODE %in% c(5201,5104))) %>% 
  tm_shape() +
  tm_fill(col = "VALUE", 
          title=get_sinim_var_name(var),
          palette = "PuRd", 
          border.col = "white", 
          style = "pretty")+
  #tm_text("MUNICIPALITY", size = 0.4) +
  tm_layout(legend.format = list(text.separator = "a", fun = mm), 
            legend.outside=T, outer.margins = c(0.05,0.10,0.05,0.10),
            inner.margins = c(0.01,0.1,0.08,0.01)) +
  tm_grid(labels.inside.frame = F, col = "#d3d3d3", alpha = 0.25, labels.size = 0.8, n.x=7, n.y=7) +
  tm_borders(col = 'black')+
  tm_scale_bar(position = c("left","bottom")) +
  tm_facets(by="NOM.REG",ncol=2)

tmap_save(tm, "map.png", width = 24, height = 12, units = "in")
