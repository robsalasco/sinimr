[![saythanks](https://img.shields.io/badge/say-thanks-ff69b4.svg)](https://saythanks.io/to/robsalasco)

# sinimR <img src="inst/image/hex/sinimR_hexSticker.png" width = "175" height = "200" align="right" /> 

Chilean Municipalities Information System Wrapper

### A note on usage

When querying the API, please be respectful of the resources required to provide this data. Please retain the results for each request to avoid repeated requests for duplicate information.

### Installation

```R
install.packages("devtools")
devtools::install_github("robsalasco/sinimr")
```

### How do I use it?

sinimR comes with a small set of functions to deliver the content of SINIM's webpage. To get a first glance of the categories of information what are available please use the ```getsinimcategories()``` command.

```R

# Load library

> library(sinimr)

# List available categories

> getsinimcategories()

$`01.  ADMINISTRACION Y FINANZAS MUNICIPALES`
                                            VARIABLE CODE
1  A.1. PRESUPUESTO INICIAL Y VIGENTE MUNICIPAL (M$)  517
2                       A. INGRESOS MUNICIPALES (M$)   21
3                        B. INGRESOS MUNICIPALES (%)  191
4                         C. GASTOS MUNICIPALES (M$)   22
5                          D. GASTOS MUNICIPALES (%)  172
6                              E. GASTOS EN PERSONAL  169
7                      F. TRANSFERENCIAS E INVERSION  170
8                   G. SERVICIOS BASICOS Y GENERALES  370
9         I. TRANSFERENCIAS Y COMPENSACIONES SUBDERE  485
10                    J. FONDO COMÚN MUNICIPAL (FCM)  508
11                              K. GESTION MUNICIPAL  486
12                                               L.    24
13                                                M.  506

$`02.  RECURSOS HUMANOS MUNICIPAL`
                VARIABLE CODE
1  A. PERSONAL DE PLANTA  381
2 B. PERSONAL A CONTRATA  382
3         C. HONORARIOS   383
4   D. OTROS INDICADORES  384

$`03.  EDUCACION MUNICIPAL`
                                    VARIABLE CODE
1     A. ANTECEDENTES GENERALES DE EDUCACION   38
2    B. ASISTENCIA Y MATRÍCULAS EN EDUCACION   32
3                          C. RESULTADOS PSU   33
4         D. INGRESOS EN EDUCACION MUNICIPAL   35
5           E. GASTOS EN EDUCACION MUNICIPAL   36
6    F. RECURSOS HUMANOS EN SECTOR EDUCACION   34
7 G. ESTABLECIMIENTOS DE EDUCACION MUNICIPAL  379

$`04.  SALUD MUNICIPAL`
                            VARIABLE CODE
1 A. ANTECEDENTES GENERALES DE SALUD   30
2    B. COBERTURA EN SALUD MUNICIPAL   25
3    C. INGRESOS  EN SALUD MUNICIPAL   26
4       D. GASTOS EN SALUD MUNICIPAL   28
5           E. RED ASISTENCIAL SALUD   31
6       F. RECURSOS HUMANOS EN SALUD  362

$`05.  SOCIAL Y COMUNITARIA`
                               VARIABLE CODE
1         A. INFORMACION ENCUESTA CASEN   47
2 B. RED SOCIAL (SUBSIDIOS Y PENSIONES)   44
3             C. INTERMEDIACION LABORAL   43
4        D. ORGANIZACIONES COMUNITARIAS   46
5                              E. BECAS  377
6            F. PARTICIPACIÓN CIUDADANA  510
7                       G. DISCAPACIDAD  512
8              H. PREVENCIÓN DEL DELITO  511

$`06.  DESARROLLO Y GESTION TERRITORIAL`
                                    VARIABLE CODE
1           A. CARACTERISTICAS TERRITORIALES   39
2        B. SERVICIOS BASICOS A LA COMUNIDAD   41
3                         C. INFRAESTRUCTURA   40
4 D. CATASTRO PREDIOS Y VALORACION CATASTRAL  300
5                           E. AREAS VERDES   376
6    F. PLAN DE DESARROLLO COMUNAL (PLADECO)  304
7                  G. PLAN REGULADOR COMUNAL   42

$`07.  CARACTERIZACION COMUNAL`
                      VARIABLE CODE
1 A. GEOGRAFICO ADMINISTRATIVA   49
2                 B. POBLACION   50
3              D. DISCAPACIDAD  366

$`08.  GENERO`
                                          VARIABLE CODE
1 A. DOTACION FUNCIONARIA Y PROFESIONAL DE MUJERES  262

$`09. CEMENTERIO`
                     VARIABLE CODE
1      1. INFORMACION GENERAL  516
2 A. INGRESOS CEMENTERIO (M$)  456
3   B. GASTOS CEMENTERIO (M$)  457
```

Every category have a bunch of variables associated. Use the CODE number and the ```getsinimvariables()``` function to get them.

```R

# List available variables

> getsinimvariables(517)

                                                      VARIABLE UNIT CODE
106                       Presupuesto Inicial Sector Municipal M$   4210
107                     Presupuesto Inicial Gastos Municipales M$   4211
108                       Presupuesto Vigente Sector Municipal M$   4212
109                     Presupuesto Vigente Gastos Municpiales M$   4213
110 Presupuesto Vigente Saldo Inicial de Caja Sector Municipal M$   4226

```

Finally, to obtain the data across municipalities use the code column and specify a year.

```R

# Get data

> head(getsinimr(c(4210,4211),2015))

   CODE  MUNICIPALITY PRESUPUESTO INICIAL GASTOS MUNICIPALES PRESUPUESTO INICIAL SECTOR MUNICIPAL
1 01101       IQUIQUE                               33387234                             33387234
2 01107 ALTO HOSPICIO                                9708323                              9708323
3 01401  POZO ALMONTE                                7270261                              7270262
4 01402        CAMIÑA                                1248620                              1248618
5 01403      COLCHANE                                2015333                              2015333
6 01404         HUARA                                3090760                              3090759
```

You can get multiple years too! use the command ```getsinimryears()``` and add more years as in the example.

```R
# Get variable by year

> head(getsinimryears(880,2015:2017))

   CODE  MUNICIPALITY YEAR INGRESOS POR FONDO COMÚN MUNICIPAL
1 01101       IQUIQUE 2015                            3257415
2 01107 ALTO HOSPICIO 2015                            6873284
3 01401  POZO ALMONTE 2015                            1788194
4 01402        CAMIÑA 2015                            1540229
5 01403      COLCHANE 2015                            1094716
6 01404         HUARA 2015                            1332312

```

If you don't know what are you looking for use ```searchsinimvar()```to get search results based on variable descriptions, names and groups.

```R
> searchsinimvar("cementerio")

    CODE                                                                                                                               VARIABLE
342 4140                                                                                          Ingresos Cementerio (Ingreso Total Percibido)
343 4141                                                                                              Gastos Cementerio (Gasto Total Devengado)
344 4406                                                                                 ¿La Municipalidad o Corporación administra Cementerio?
345 4407 Si la Municipalidad o Corporación administra Cementerio, indique si tiene presupuesto propio. SI = presupuesto propio o independiente.
                                                                                                                                                                 DESCRIPTION
342                                                                                              Ingreso total percibido del sector Cementerio (clasificador presupuestario)
343                                                                                                  Gastos total devengado sector Cementerio (clasificador presupuestario).
344 Indica si la Municipalidad o Corporación administra o no Cementerio Municipal, ya sea con presupuesto propio o asociado a otro sector de la municipalidad o corporación.
345                                             Indica si administra un presupuesto independiente o anexo a otro sector de la municipalidad, como Salud, Municipalidad, etc.
              AREA                     SUBAREA UNIT
342 09. CEMENTERIO A. INGRESOS CEMENTERIO (M$) M$  
343 09. CEMENTERIO   B. GASTOS CEMENTERIO (M$) M$  
344 09. CEMENTERIO      1. INFORMACION GENERAL S-N 
345 09. CEMENTERIO      1. INFORMACION GENERAL S-N 

```

### Example plot

```R
library(dplyr)
library(sinimr)
library(geojsonsf)
library(sf)
library(tmap)

reg13 <- geojson_sf("http://datos.cedeus.cl/geoserver/wfs?srsName=EPSG%3A4326&typename=geonode%3Acomunas_stgo_based_on_bcn_probreza_casen2013_v2&outputFormat=json&version=1.0.0&service=WFS&request=GetFeature")

comunas <- c("CERRILLOS", "LA REINA", "PUDAHUEL", "CERRO NAVIA", "LAS CONDES",
             "QUILICURA", "CONCHALÍ", "LO BARNECHEA", "QUINTA NORMAL", "EL BOSQUE",
             "LO ESPEJO", "RECOLETA", "ESTACIÓN CENTRAL", "LO PRADO", "RENCA", "HUECHURABA",
             "MACUL", "SAN MIGUEL", "INDEPENDENCIA", "MAIPÚ", "SAN JOAQUÍN", "LA CISTERNA", "ÑUÑOA",
             "SAN RAMÓN", "LA FLORIDA", "PEDRO AGUIRRE CERDA", "SANTIAGO", "LA PINTANA", "PEÑALOLÉN",
             "VITACURA", "LA GRANJA", "PROVIDENCIA", "PADRE HURTADO", "SAN BERNARDO", "PUENTE ALTO", "PIRQUE")

var <- getsinimr(882, 2017) %>% filter(MUNICIPALITY %in% comunas)

var.reg13.join <- reg13 %>%
  select(c_Cod) %>% 
  transmute(CODE = as.character(c_Cod)) %>%
  right_join(var, by=c("CODE"))

tm_shape(var.reg13.join) +
  tm_polygons(names(var.reg13.join)[3], palette="viridis")+
  tm_text(names(var.reg13.join)[2], size = 0.4,style="jenks") +
  tm_legend(legend.position = c("left", "top")) +  
  tm_compass(type = "8star", position = c("right", "bottom")) +
  tm_scale_bar(breaks = c(0, 10), size = 0.75, position = c("right", "bottom"), width = 1) +
  tm_credits("Fuente: Sistema Nacional de Información Municipal (SINIM), SUBDERE, Ministerio del Interior.", position=c("left", "bottom"), size=0.5)
```

![](plot.png)




