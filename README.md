# SINIMr 0.0.4 (Beta)

Chilean Municipalities Information System Wrapper

A note on usage

When querying the API, please be respectful of the resources required to provide this data. We recommend you retain the results for each request so you can avoid repeated requests for duplicate information.

###Installation

```R
install.packages("devtools")
devtools::install_github("robsalasco/sinimr")
```

Example usage

```R
# include the helper library
library(sinimr)

# list available categories
getsinimcategories()

# list available variables
getsinimvariables("A. INGRESOS MUNICIPALES (M$)")

# get data
getsinimr(c(3752,3954,880),2015)

# get variable by year
getsinimr(880,c(2015,2014,2013))

```
