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

reg13 <- read_sf("https://raw.githubusercontent.com/robsalasco/precenso_2016_geojson_chile/master/GRAN_SANTIAGO.geojson")

comunas <- c("CERRILLOS", "LA REINA", "PUDAHUEL", "CERRO NAVIA", "LAS CONDES",
             "QUILICURA", "CONCHALÍ", "LO BARNECHEA", "QUINTA NORMAL", "EL BOSQUE",
             "LO ESPEJO", "RECOLETA", "ESTACIÓN CENTRAL", "LO PRADO", "RENCA", "HUECHURABA",
             "MACUL", "SAN MIGUEL", "INDEPENDENCIA", "MAIPÚ", "SAN JOAQUÍN", "LA CISTERNA", "ÑUÑOA",
             "SAN RAMÓN", "LA FLORIDA", "PEDRO AGUIRRE CERDA", "SANTIAGO", "LA PINTANA", "PEÑALOLÉN",
             "VITACURA", "LA GRANJA", "PROVIDENCIA", "SAN BERNARDO", "PUENTE ALTO", "PADRE HURTADO", "PIRQUE", 
             "SAN JOSÉ DE MAIPO")

var <- getsinimr(882, 2017) %>% filter(MUNICIPALITY %in% comunas)

var[3] <- var[3]*1000

var.reg13.join <- reg13 %>%
  select(COMUNA) %>% 
  transmute(CODE = as.character(COMUNA)) %>%
  right_join(var, by=c("CODE"))

tm_shape(var.reg13.join) +
  tm_polygons(names(var.reg13.join)[3], palette="inferno", border.col = "white") +
  tm_text(names(var.reg13.join)[2], size = 0.4, style="jenks") +
  tm_legend(legend.position = c("left", "top")) +
  tm_compass(type = "8star", position = c("left", "bottom")) +
  tm_scale_bar(breaks = c(0, 10), size = 0.75, position = c("right", "bottom"), width = 1) +
  tm_credits("Fuente: Sistema Nacional de Información Municipal (SINIM), SUBDERE, Ministerio del Interior.", position=c("left", "bottom"), size=0.55)

```

![](plot.png)

### Dataset included

```R

data("idgeocensus")

> idgeocensus
    REGION                    NOM_REGION PROVINCIA           NOM_PROVINCIA COMUNA           NOM_COMUNA
1       12                    MAGALLANES       121              MAGALLANES  12101         PUNTA ARENAS
2       12                    MAGALLANES       121              MAGALLANES  12102        LAGUNA BLANCA
3       12                    MAGALLANES       121              MAGALLANES  12103            RÍO VERDE
4       12                    MAGALLANES       121              MAGALLANES  12104         SAN GREGORIO
5       12                    MAGALLANES       122       ANTÁRTICA CHILENA  12201       CABO DE HORNOS
6       12                    MAGALLANES       122       ANTÁRTICA CHILENA  12202            ANTÁRTICA
7       12                    MAGALLANES       123        TIERRA DEL FUEGO  12301             PORVENIR
8       12                    MAGALLANES       123        TIERRA DEL FUEGO  12302            PRIMAVERA
9       12                    MAGALLANES       123        TIERRA DEL FUEGO  12303             TIMAUKEL
10      12                    MAGALLANES       124        ÚLTIMA ESPERANZA  12401              NATALES
11      12                    MAGALLANES       124        ÚLTIMA ESPERANZA  12402     TORRES DEL PAINE
12      11                         AYSÉN       111               COYHAIQUE  11101            COYHAIQUE
13      11                         AYSÉN       111               COYHAIQUE  11102           LAGO VERDE
14      11                         AYSÉN       112                   AYSÉN  11201                AYSÉN
15      11                         AYSÉN       112                   AYSÉN  11202               CISNES
16      11                         AYSÉN       112                   AYSÉN  11203            GUAITECAS
17      11                         AYSÉN       113            CAPITÁN PRAT  11301             COCHRANE
18      11                         AYSÉN       113            CAPITÁN PRAT  11302            O'HIGGINS
19      11                         AYSÉN       113            CAPITÁN PRAT  11303               TORTEL
20      11                         AYSÉN       114         GENERAL CARRERA  11401          CHILE CHICO
21      11                         AYSÉN       114         GENERAL CARRERA  11402           RÍO IBÁÑEZ
22       1                      TARAPACÁ        11                 IQUIQUE   1101              IQUIQUE
23       1                      TARAPACÁ        11                 IQUIQUE   1107        ALTO HOSPICIO
24       1                      TARAPACÁ        14               TAMARUGAL   1401         POZO ALMONTE
25       1                      TARAPACÁ        14               TAMARUGAL   1402               CAMIÑA
26       1                      TARAPACÁ        14               TAMARUGAL   1403             COLCHANE
27       1                      TARAPACÁ        14               TAMARUGAL   1404                HUARA
28       1                      TARAPACÁ        14               TAMARUGAL   1405                 PICA
29       2                   ANTOFAGASTA        21             ANTOFAGASTA   2101          ANTOFAGASTA
30       2                   ANTOFAGASTA        21             ANTOFAGASTA   2102           MEJILLONES
31       2                   ANTOFAGASTA        21             ANTOFAGASTA   2103         SIERRA GORDA
32       2                   ANTOFAGASTA        21             ANTOFAGASTA   2104               TALTAL
33       2                   ANTOFAGASTA        22                  EL LOA   2201               CALAMA
34       2                   ANTOFAGASTA        22                  EL LOA   2202              OLLAGÜE
35       2                   ANTOFAGASTA        22                  EL LOA   2203 SAN PEDRO DE ATACAMA
36       2                   ANTOFAGASTA        23               TOCOPILLA   2301            TOCOPILLA
37       2                   ANTOFAGASTA        23               TOCOPILLA   2302          MARÍA ELENA
38      10                     LOS LAGOS       101              LLANQUIHUE  10101         PUERTO MONTT
39      10                     LOS LAGOS       101              LLANQUIHUE  10102              CALBUCO
40      10                     LOS LAGOS       101              LLANQUIHUE  10103              COCHAMÓ
41      10                     LOS LAGOS       101              LLANQUIHUE  10104               FRESIA
42      10                     LOS LAGOS       101              LLANQUIHUE  10105            FRUTILLAR
43      10                     LOS LAGOS       101              LLANQUIHUE  10106          LOS MUERMOS
44      10                     LOS LAGOS       101              LLANQUIHUE  10107           LLANQUIHUE
45      10                     LOS LAGOS       101              LLANQUIHUE  10108              MAULLÍN
46      10                     LOS LAGOS       101              LLANQUIHUE  10109         PUERTO VARAS
47      10                     LOS LAGOS       102                  CHILOÉ  10201               CASTRO
48      10                     LOS LAGOS       102                  CHILOÉ  10202                ANCUD
49      10                     LOS LAGOS       102                  CHILOÉ  10203              CHONCHI
50      10                     LOS LAGOS       102                  CHILOÉ  10204      CURACO DE VÉLEZ
51      10                     LOS LAGOS       102                  CHILOÉ  10205             DALCAHUE
52      10                     LOS LAGOS       102                  CHILOÉ  10206            PUQUELDÓN
53      10                     LOS LAGOS       102                  CHILOÉ  10207              QUEILÉN
54      10                     LOS LAGOS       102                  CHILOÉ  10208              QUELLÓN
55      10                     LOS LAGOS       102                  CHILOÉ  10209              QUEMCHI
56      10                     LOS LAGOS       102                  CHILOÉ  10210             QUINCHAO
57      10                     LOS LAGOS       103                  OSORNO  10301               OSORNO
58      10                     LOS LAGOS       103                  OSORNO  10302         PUERTO OCTAY
59      10                     LOS LAGOS       103                  OSORNO  10303            PURRANQUE
60      10                     LOS LAGOS       103                  OSORNO  10304              PUYEHUE
61      10                     LOS LAGOS       103                  OSORNO  10305            RÍO NEGRO
62      10                     LOS LAGOS       103                  OSORNO  10306 SAN JUAN DE LA COSTA
63      10                     LOS LAGOS       103                  OSORNO  10307            SAN PABLO
64      10                     LOS LAGOS       104                  PALENA  10401              CHAITÉN
65      10                     LOS LAGOS       104                  PALENA  10402            FUTALEUFÚ
66      10                     LOS LAGOS       104                  PALENA  10403            HUALAIHUÉ
67      10                     LOS LAGOS       104                  PALENA  10404               PALENA
68      15            ARICA Y PARINACOTA       151                   ARICA  15101                ARICA
69      15            ARICA Y PARINACOTA       151                   ARICA  15102            CAMARONES
70      15            ARICA Y PARINACOTA       152              PARINACOTA  15201                PUTRE
71      15            ARICA Y PARINACOTA       152              PARINACOTA  15202        GENERAL LAGOS
72       5                    VALPARAÍSO        51              VALPARAÍSO   5101           VALPARAÍSO
73       5                    VALPARAÍSO        51              VALPARAÍSO   5102           CASABLANCA
74       5                    VALPARAÍSO        51              VALPARAÍSO   5103               CONCÓN
75       5                    VALPARAÍSO        51              VALPARAÍSO   5104       JUAN FERNÁNDEZ
76       5                    VALPARAÍSO        51              VALPARAÍSO   5105           PUCHUNCAVÍ
77       5                    VALPARAÍSO        51              VALPARAÍSO   5107             QUINTERO
78       5                    VALPARAÍSO        51              VALPARAÍSO   5109         VIÑA DEL MAR
79       5                    VALPARAÍSO        52          ISLA DE PASCUA   5201       ISLA DE PASCUA
80       5                    VALPARAÍSO        53               LOS ANDES   5301            LOS ANDES
81       5                    VALPARAÍSO        53               LOS ANDES   5302          CALLE LARGA
82       5                    VALPARAÍSO        53               LOS ANDES   5303            RINCONADA
83       5                    VALPARAÍSO        53               LOS ANDES   5304          SAN ESTEBAN
84       5                    VALPARAÍSO        54                 PETORCA   5401             LA LIGUA
85       5                    VALPARAÍSO        54                 PETORCA   5402              CABILDO
86       5                    VALPARAÍSO        54                 PETORCA   5403               PAPUDO
87       5                    VALPARAÍSO        54                 PETORCA   5404              PETORCA
88       5                    VALPARAÍSO        54                 PETORCA   5405             ZAPALLAR
89       5                    VALPARAÍSO        55                QUILLOTA   5501             QUILLOTA
90       5                    VALPARAÍSO        55                QUILLOTA   5502               CALERA
91       5                    VALPARAÍSO        55                QUILLOTA   5503             HIJUELAS
92       5                    VALPARAÍSO        55                QUILLOTA   5504              LA CRUZ
93       5                    VALPARAÍSO        55                QUILLOTA   5506              NOGALES
94       5                    VALPARAÍSO        56             SAN ANTONIO   5601          SAN ANTONIO
95       5                    VALPARAÍSO        56             SAN ANTONIO   5602            ALGARROBO
96       5                    VALPARAÍSO        56             SAN ANTONIO   5603            CARTAGENA
97       5                    VALPARAÍSO        56             SAN ANTONIO   5604            EL QUISCO
98       5                    VALPARAÍSO        56             SAN ANTONIO   5605              EL TABO
99       5                    VALPARAÍSO        56             SAN ANTONIO   5606        SANTO DOMINGO
100      5                    VALPARAÍSO        57 SAN FELIPE DE ACONCAGUA   5701           SAN FELIPE
101      5                    VALPARAÍSO        57 SAN FELIPE DE ACONCAGUA   5702               CATEMU
102      5                    VALPARAÍSO        57 SAN FELIPE DE ACONCAGUA   5703             LLAILLAY
103      5                    VALPARAÍSO        57 SAN FELIPE DE ACONCAGUA   5704            PANQUEHUE
104      5                    VALPARAÍSO        57 SAN FELIPE DE ACONCAGUA   5705             PUTAENDO
105      5                    VALPARAÍSO        57 SAN FELIPE DE ACONCAGUA   5706          SANTA MARÍA
106      5                    VALPARAÍSO        58             MARGA MARGA   5801              QUILPUÉ
107      5                    VALPARAÍSO        58             MARGA MARGA   5802              LIMACHE
108      5                    VALPARAÍSO        58             MARGA MARGA   5803                OLMUÉ
109      5                    VALPARAÍSO        58             MARGA MARGA   5804        VILLA ALEMANA
110      3                       ATACAMA        31                 COPIAPÓ   3102              CALDERA
111      3                       ATACAMA        33                  HUASCO   3301             VALLENAR
112      3                       ATACAMA        33                  HUASCO   3302      ALTO DEL CARMEN
113      3                       ATACAMA        33                  HUASCO   3303             FREIRINA
114      3                       ATACAMA        33                  HUASCO   3304               HUASCO
115      4                      COQUIMBO        41                   ELQUI   4101            LA SERENA
116      4                      COQUIMBO        41                   ELQUI   4102             COQUIMBO
117      4                      COQUIMBO        41                   ELQUI   4103            ANDACOLLO
118      4                      COQUIMBO        41                   ELQUI   4104           LA HIGUERA
119      4                      COQUIMBO        41                   ELQUI   4105             PAIGUANO
120      4                      COQUIMBO        41                   ELQUI   4106               VICUÑA
121      4                      COQUIMBO        42                  CHOAPA   4201              ILLAPEL
122      4                      COQUIMBO        42                  CHOAPA   4202               CANELA
123      4                      COQUIMBO        42                  CHOAPA   4203            LOS VILOS
124      4                      COQUIMBO        42                  CHOAPA   4204            SALAMANCA
125      4                      COQUIMBO        43                  LIMARÍ   4301               OVALLE
126      4                      COQUIMBO        43                  LIMARÍ   4302           COMBARBALÁ
127      4                      COQUIMBO        43                  LIMARÍ   4303         MONTE PATRIA
128      4                      COQUIMBO        43                  LIMARÍ   4304            PUNITAQUI
129      4                      COQUIMBO        43                  LIMARÍ   4305          RÍO HURTADO
130      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6101             RANCAGUA
131      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6102              CODEGUA
132      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6103               COINCO
133      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6104             COLTAUCO
134      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6105              DOÑIHUE
135      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6106             GRANEROS
136      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6107           LAS CABRAS
137      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6108              MACHALÍ
138      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6109               MALLOA
139      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6110             MOSTAZAL
140      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6111               OLIVAR
141      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6112                PEUMO
142      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6113           PICHIDEGUA
143      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6114    QUINTA DE TILCOCO
144      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6115                RENGO
145      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6116             REQUÍNOA
146      6 LIBERTADOR BERNARDO O’HIGGINS        61               CACHAPOAL   6117          SAN VICENTE
147      6 LIBERTADOR BERNARDO O’HIGGINS        62           CARDENAL CARO   6201            PICHILEMU
148      6 LIBERTADOR BERNARDO O’HIGGINS        62           CARDENAL CARO   6202          LA ESTRELLA
149      6 LIBERTADOR BERNARDO O’HIGGINS        62           CARDENAL CARO   6203             LITUECHE
150      6 LIBERTADOR BERNARDO O’HIGGINS        62           CARDENAL CARO   6204            MARCHIHUE
151      6 LIBERTADOR BERNARDO O’HIGGINS        62           CARDENAL CARO   6205              NAVIDAD
152      6 LIBERTADOR BERNARDO O’HIGGINS        62           CARDENAL CARO   6206            PAREDONES
153      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6301         SAN FERNANDO
154      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6302              CHÉPICA
155      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6303          CHIMBARONGO
156      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6304                LOLOL
157      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6305             NANCAGUA
158      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6306             PALMILLA
159      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6307            PERALILLO
160      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6308             PLACILLA
161      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6309             PUMANQUE
162      6 LIBERTADOR BERNARDO O’HIGGINS        63               COLCHAGUA   6310           SANTA CRUZ
163      7                         MAULE        71                   TALCA   7101                TALCA
164      7                         MAULE        71                   TALCA   7102         CONSTITUCIÓN
165      7                         MAULE        71                   TALCA   7103              CUREPTO
166      7                         MAULE        71                   TALCA   7104            EMPEDRADO
 [ reached getOption("max.print") -- omitted 180 rows ]
 
```


