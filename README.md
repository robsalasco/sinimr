# SINIMr 0.1.1

Chilean Municipalities Information System Wrapper

A note on usage

When querying the API, please be respectful of the resources required to provide this data. We recommend you retain the results for each request so you can avoid repeated requests for duplicate information.

### Installation

```R
install.packages("devtools")
devtools::install_github("robsalasco/sinimr")
```

Example usage

```R
# include the helper library

> library(sinimr)

# list available categories

> getsinimcategories()

 [1] "A. INGRESOS MUNICIPALES (M$)"                     "B. INGRESOS MUNICIPALES (%)"                     
 [3] "C. GASTOS MUNICIPALES (M$)"                       "D. GASTOS MUNICIPALES (%)"                       
 [5] "E. GASTOS EN PERSONAL"                            "F. TRANSFERENCIAS E INVERSION"                   
 [7] "G. SERVICIOS BASICOS Y GENERALES"                 "I. TRANSFERENCIAS Y COMPENSACIONES SUBDERE"      
 [9] "J. FONDO COMÚN MUNICIPAL (FCM)"                   "K. GESTION MUNICIPAL"                            
[11] "A. PERSONAL DE PLANTA"                            "B. PERSONAL A CONTRATA"                          
[13] "C. HONORARIOS "                                   "D. OTROS INDICADORES"                            
[15] "A. ANTECEDENTES GENERALES DE EDUCACION"           "B. ASISTENCIA Y MATRÍCULAS EN EDUCACION"         
[17] "C. RESULTADOS PSU"                                "D. INGRESOS EN EDUCACION MUNICIPAL"              
[19] "E. GASTOS EN EDUCACION MUNICIPAL"                 "F. RECURSOS HUMANOS EN SECTOR EDUCACION"         
[21] "G. ESTABLECIMIENTOS DE EDUCACION MUNICIPAL"       "A. ANTECEDENTES GENERALES DE SALUD"              
[23] "B. COBERTURA EN SALUD MUNICIPAL"                  "C. INGRESOS  EN SALUD MUNICIPAL"                 
[25] "D. GASTOS EN SALUD MUNICIPAL"                     "E. RED ASISTENCIAL SALUD"                        
[27] "F. RECURSOS HUMANOS EN SALUD"                     "A. INFORMACION ENCUESTA CASEN"                   
[29] "B. FICHA DE PROTECCION SOCIAL (FPS)"              "C. RED SOCIAL (SUBSIDIOS Y PENSIONES)"           
[31] "D. INTERMEDIACION LABORAL"                        "E. ORGANIZACIONES COMUNITARIAS"                  
[33] "F. BECAS"                                         "G. PARTICIPACIÓN CIUDADANA"                      
[35] "H. PREVENCIÓN DEL DELITO"                         "I. DISCAPACIDAD"                                 
[37] "A. CARACTERISTICAS TERRITORIALES"                 "B. SERVICIOS BASICOS A LA COMUNIDAD"             
[39] "C. INFRAESTRUCTURA"                               "D. CATASTRO PREDIOS Y VALORACION CATASTRAL"      
[41] "F. PLAN DE DESARROLLO COMUNAL (PLADECO)"          "G. PLAN REGULADOR COMUNAL"                       
[43] "A. GEOGRAFICO ADMINISTRATIVA"                     "B. POBLACION"                                    
[45] "A. PRECARIEDAD SOCIOECONOMICA MUJERES"            "B. DOTACION FUNCIONARIA Y PROFESIONAL DE MUJERES"
[47] "A. INGRESOS CEMENTERIO (M$)"                      "B. GASTOS CEMENTERIO (M$)"   

# list available variables

> getsinimvariables("A. INGRESOS MUNICIPALES (M$)")

                                                                                        VARIABLE VALUE
1                                                                Casinos de Juegos Ley Nº19.995.  3752
2                                                                               Derechos de Aseo  3954
3                                       Derechos de Aseo Cobro Directo y de Patentes Comerciales  3955
4                                                      Derechos de Aseo por Impuesto Territorial  3956
5                                  Impuesto Territorial de Beneficio Municipal (Art. 37 DL 3063)  4251
6                                                 Ingresos Municipales (Ingreso Total Percibido)  1110
7                       Ingresos Municipales (Ingreso Total Percibido) sin Saldo Inicial de Caja  4245
8                                                             Ingresos por Fondo Común Municipal   880
9                                                                         Ingresos por Impuestos  1226
10                                      Ingresos por Patentes Municipales de Beneficio Municipal  4173
11                                   Ingresos por Permisos de Circulación de Beneficio Municipal  4174
12                                                                   Ingresos por Transferencias   883
13 Ingresos por Transferencias menos Casino Ley N° 19.995, Patentes Acuícolas y Patentes Mineras  4325
14                                                                  Ingresos Propios (IPP y FCM)   882
15                                                            Ingresos Propios Permanentes (IPP)   879
16                                                Ingresos Propios Permanentes per Cápita (IPPP)  1262
17                       Ingresos Propios, según criterio de Contraloría General de la República   890
18                                 Ingresos Totales, descontados los Ingresos por Transferencias   887
19                                                            Monto Patentes Municipales Pagadas  1311
20                                                       Patentes Acuícolas Ley Nº20.033 Art. 8.  3753
21                                                                Patentes Mineras Ley Nº19.143.  3754
22                                                          Presupuesto Inicial Sector Municipal  4210
23                                    Presupuesto Vigente Saldo Inicial de Caja Sector Municipal  4226
24                                                          Presupuesto Vigente Sector Municipal  4212

# get data

> head(getsinimr(c(3752,3954,880),2015))

  CODIGO     MUNICIPIO CASINOS DE JUEGOS LEY Nº19.995. DERECHOS DE ASEO INGRESOS POR FONDO COMÚN MUNICIPAL
1  01101       IQUIQUE                               0          1072850                            2927867
2  01107 ALTO HOSPICIO                               0           124979                            6048042
3  01401  POZO ALMONTE                              NA             <NA>                               <NA>
4  01402        CAMIÑA                               0              288                            1394263
5  01403      COLCHANE                               0              749                             984534
6  01404         HUARA                               0             1072                            1166072

# get variable by year

> getsinimryears(880,c(2015,2014,2013))

  CODIGO     MUNICIPIO variable   value
1  01101       IQUIQUE     2015 2927867
2  01107 ALTO HOSPICIO     2015 6048042
3  01401  POZO ALMONTE     2015      NA
4  01402        CAMIÑA     2015 1394263
5  01403      COLCHANE     2015  984534
6  01404         HUARA     2015 1166072

```
