library(tmap)
library(sinimr)

get_sinim(880, 2018, region=13, geometry=T, truevalue = T, auc = T, unit = "limites") %>% 
  tm_shape() +
  tm_fill(col = "VALUE", 
          title=get_sinim_var_name(880),
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

get_sinim(880, 2018, provincia = 14, auc=T, unit = "limites")
