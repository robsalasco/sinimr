library(sinimr)

auc1 <- c("CERRILLOS", "LA REINA", "PUDAHUEL", "CERRO NAVIA", "LAS CONDES",
"QUILICURA", "CONCHALÍ", "LO BARNECHEA", "QUINTA NORMAL", "EL BOSQUE",
"LO ESPEJO", "RECOLETA", "ESTACIÓN CENTRAL", "LO PRADO", "RENCA", "HUECHURABA",
"MACUL", "SAN MIGUEL", "INDEPENDENCIA", "MAIPÚ", "SAN JOAQUÍN", "LA CISTERNA", "ÑUÑOA",
"SAN RAMÓN", "LA FLORIDA", "PEDRO AGUIRRE CERDA", "SANTIAGO", "LA PINTANA", "PEÑALOLÉN",
"VITACURA", "LA GRANJA", "PROVIDENCIA", "SAN BERNARDO", "PUENTE ALTO", "PADRE HURTADO", "PIRQUE",
"SAN JOSÉ DE MAIPO")

auc2 <- c("CONCEPCIÓN", "CORONEL", "CHIGUAYANTE", "HUALPÉN", "HUALQUI", "LOTA",
          "PENCO", "SAN PEDRO DE LA PAZ", "TALCAHUANO", "TOMÉ")

auc3 <- c( "VALPARAÍSO", "VIÑA DEL MAR", "QUILPUÉ", "VILLA ALEMANA", "CONCÓN")

auc4 <- c("LA SERENA", "COQUIMBO")

auc5 <- c("TEMUCO", "PADRE LAS CASAS")

auc6 <- c("IQUIQUE","ALTO HOSPICIO")

auc7 <- c("RANCAGUA", "MACHALÍ", "OLIVAR", "REQUINOA")

auc8 <- c("PUERTO MONTT")

auc9 <- c("PUERTO VARAS")

auc10 <- c("ARICA")

auc11 <- c("TALCA")

auc12 <- c("CHILLÁN", "CHILLÁN VIEJO")

auc13 <- c("LOS ÁNGELES")

c.list <- c(auc1,auc2,auc3,auc4,auc5,auc6,auc7,auc8,auc9,auc10,auc11,auc12,auc13)

id_geo_census$AUC <- ifelse(id_geo_census$MUNICIPALITY %in% c.list,1,0)

save(id_geo_census, file="data/id_geo_census.rda")
