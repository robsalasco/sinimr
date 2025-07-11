#' @import httr
#' @import XML
#' @importFrom jsonlite fromJSON
#' @importFrom reshape2 melt
#' @importFrom stats complete.cases

# Helper functions for API calls, data parsing, and variable lookups used throughout the sinimr package.

# Register global variables to avoid CRAN NOTES about undefined variables in data manipulation code.
utils::globalVariables(c(
  "id_geo_census", "code.reg", "code.prov", "code",
  "census_geometry_comunas", "census_geometry_limites", "id_subarea"
))

# Call the SINIM API with a GET request and return the raw response as a string.
callapi <- function(url) { # nocov start
  resp <- httr::GET(url, add_headers("X-Request-Source" = "r"))
  stop_for_status(resp, task = "call api")
  data <- httr::content(resp, "text", encoding = "UTF-8")
  data <- substr(data, 2, nchar(data))
  
  return(data)
} # nocov end

# Call the SINIM API with a POST request and return the parsed JSON response.
postapi <- function(url, body) { # nocov start
  resp <- httr::POST(
    url,
    body = body,
    add_headers(
      "User-Agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/18.3.1 Safari/605.1.15",
      "Referer" = "https://datos.sinim.gov.cl/datos_municipales.php",
      "Host" = "datos.sinim.gov.cl",
      "X-Requested-With" = "XMLHttpRequest",
      "Accept-Encoding" = "gzip, deflate, br"
    )
  )
  
  stop_for_status(resp, task = "call api")
  
  data <- jsonlite::fromJSON(content(resp, "text"))
  return(data)
} # nocov end

# Validate and convert a year or vector of years to their index in the supported year list.
getyear <- function(year) { # nocov start
  year_list <- c(
    2000,
    2001,
    2002,
    2003,
    2004,
    2005,
    2006,
    2007,
    2008,
    2009,
    2010,
    2011,
    2012,
    2013,
    2014,
    2015,
    2016,
    2017,
    2018,
    2019,
    2020,
    2021,
    2022,
    2023,
    2024
  )
  if (any(is.na(match(year, year_list)))) {
    stop("Year not found in list")
  } else {
    return(match(year, year_list))
  }
} # nocov end

# Retrieve the internal SINIM variable ID(s) for a given variable name or names.
getid <- function(name) { # nocov start
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <-
    postapi(
      "https://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
      body
    )
  list <- reshape2::melt(sapply(resp, function(b)
    b$mtro_datos_nombre))
  values <- reshape2::melt(sapply(resp, function(b)
    b$id_dato))
  list$id <- values$value
  colnames(list) <- c("variable", "category", "value")
  list$variable <-
    as.vector(lapply(as.character(list$variable), function(x)
      trimws(x)))
  return(list[complete.cases(match(list$variable, name)), 3])
} # nocov end

# Retrieve the SINIM variable name(s) for a given variable code or codes.
getname <- function(names) { # nocov start
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <- postapi(
      "https://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
      body
    )
  list <- reshape2::melt(sapply(resp, function(b)
    b$mtro_datos_nombre))
  values <- reshape2::melt(sapply(resp, function(b)
    b$id_dato))
  list$id <- values$value
  colnames(list) <- c("variable", "category", "value")
  list$variable <-
    as.vector(lapply(as.character(list$variable), function(x)
      trimws(x)))
  names.list <- gsub("\\.", "", toupper(unlist(list[which(list$value %in% names), 1])))
  return(names.list)
} # nocov end

# Parse XML data from the SINIM API for the given variables and years, optionally applying monetary correction.
parsexml <- function(var, years, moncorr=T) { # nocov start
    yearsn <- getyear(years)
    if(moncorr==T){
      url <- paste(
        "https://datos.sinim.gov.cl/datos_municipales/obtener_datos_municipales.php?area[]=T&subarea[]=T&variables[]=",
        paste(var, collapse = ","), "&periodos[]=", paste(yearsn, collapse = ","), "&regiones[]=T&municipios[]=T&corrmon=1",
        sep = ""
      )
    } else {
      url <- paste(
        "https://datos.sinim.gov.cl/datos_municipales/obtener_datos_municipales.php?area[]=T&subarea[]=T&variables[]=",
        paste(var, collapse = ","), "&periodos[]=", paste(yearsn, collapse = ","), "&regiones[]=T&municipios[]=T&corrmon=0",
        sep = ""
      )
    }
    data <- XML::xmlParse(callapi(url))
    columns <- as.numeric(
      XML::xpathApply(
        data,
        "//tei:Table/@tei:ExpandedColumnCount",
        namespaces = c(tei = getDefaultNamespace(data)[[1]]$uri)
      )[[1]][[1]],
      xmlValue
    )
    varxml <- XML::xpathSApply(
      data,
      "//tei:Cell[not(@tei:StyleID)]",
      namespaces = c(tei = getDefaultNamespace(data)[[1]]$uri),
      xmlValue
    )
    values <- matrix(varxml, 
                     nrow = length(varxml)/((length(var)*length(yearsn))+2), 
                     ncol = ((length(var)*length(yearsn))+2), byrow = T)
    values <- as.data.frame(values, stringsAsFactors = F)
    return(values)
} # nocov end

# Construct column names for variables and years in the format VARIABLE.YEAR.
namesco <- function(x,y){ #nocov start
  rep_vars <- rep(getname(x), each=length(y))
  rep_years <- rep(sort(y, decreasing = T), length(x))
  return(paste(rep_vars, rep_years, sep="."))
} # nocov end

# Filter geographic codes by region, province, or comuna, with optional AUC filtering.
geofilter <- function(region, provincia, comuna, auc=F) { #nocov start
  if (!missing(region)) {
    stopifnot(missing(provincia))
    stopifnot(missing(comuna))
    if(auc==T) {
      selection <- subset(id_geo_census, code.reg %in% region &
                            auc==1)$code
    } else {
      selection <- subset(id_geo_census, code.reg %in% region)$code
    }
    return(selection)
  } else if (!missing(provincia)) {
    stopifnot(missing(region))
    stopifnot(missing(comuna))
    if(auc==T) {
      warning("AUC not available subsetting provincias")
    }
    selection <- subset(id_geo_census, code.prov %in% provincia)$code
    return(selection)
  } else if (!missing(comuna)) {
    stopifnot(missing(region))
    stopifnot(missing(provincia))
    if(auc==T) {
      warning("AUC not available subsetting comunas")
    }
    selection <- subset(id_geo_census, code %in% comuna)$code
    return(selection)
  } else {
    return(id_geo_census$code)
  }
} # nocov end
