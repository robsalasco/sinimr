#' @import httr
#' @import XML
#' @importFrom jsonlite fromJSON
#' @importFrom reshape2 melt
#' @importFrom stats complete.cases

callapi <- function(url) { # nocov start
  resp <- httr::GET(url, add_headers("X-Request-Source" = "r"))
  stop_for_status(resp)
  data <- httr::content(resp, "text", encoding = "UTF-8")
  data <- substr(data, 2, nchar(data))
  return(data)
} # nocov end

postapi <- function(url, body) { # nocov start
  resp <- httr::POST(
    url,
    body = body,
    add_headers(
      "User-Agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36",
      "Referer" = "http://datos.sinim.gov.cl/datos_municipales.php",
      "Host" = "datos.sinim.gov.cl",
      "X-Requested-With" = "XMLHttpRequest"
    )
  )
  stop_for_status(resp)
  data <- jsonlite::fromJSON(content(resp, "text"))
  return(data)
} # nocov end

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
    2018
  )
  if (any(is.na(match(year, year_list)))) {
    stop("Year not found in list")
  } else {
    return(match(year, year_list))
  }
} # nocov end

getid <- function(name) { # nocov start
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <-
    postapi(
      "http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
      body
    )
  list <- reshape2::melt(sapply(resp, function(b)
    b$mtro_datos_nombre))
  values <- reshape2::melt(sapply(resp, function(b)
    b$id_dato))
  list$id <- values$value
  colnames(list) <- c("VARIABLE", "CATEGORY", "VALUE")
  list$VARIABLE <-
    as.vector(lapply(as.character(list$VARIABLE), function(x)
      trimws(x)))
  return(list[complete.cases(match(list$VARIABLE, name)), 3])
} # nocov end

getname <- function(names) { # nocov start
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <- postapi(
      "http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
      body
    )
  list <- reshape2::melt(sapply(resp, function(b)
    b$mtro_datos_nombre))
  values <- reshape2::melt(sapply(resp, function(b)
    b$id_dato))
  list$id <- values$value
  colnames(list) <- c("VARIABLE", "CATEGORY", "VALUE")
  list$VARIABLE <-
    as.vector(lapply(as.character(list$VARIABLE), function(x)
      trimws(x)))
  names.list <- gsub("\\.", "", toupper(unlist(list[which(list$VALUE %in% names), 1])))
  return(names.list)
} # nocov end

parsexml <- function(var, years, moncorr=T) { # nocov start
    yearsn <- getyear(years)
    if(moncorr==T){
      url <- paste(
        "http://datos.sinim.gov.cl/datos_municipales/obtener_datos_municipales.php?area[]=T&subarea[]=T&variables[]=",
        paste(var, collapse = ","), "&periodos[]=", paste(yearsn, collapse = ","), "&regiones[]=T&municipios[]=T&corrmon=1",
        sep = ""
      )
    } else {
      url <- paste(
        "http://datos.sinim.gov.cl/datos_municipales/obtener_datos_municipales.php?area[]=T&subarea[]=T&variables[]=",
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

namesco <- function(x,y){ #nocov start
  rep_vars <- rep(getname(x), each=length(y))
  rep_years <- rep(sort(y, decreasing = T), length(x))
  return(paste(rep_vars, rep_years, sep="."))
} # nocov end

geofilter <- function(region, provincia, comuna) { #nocov start
  if (!missing(region)) {
    stopifnot(missing(provincia))
    stopifnot(missing(comuna))
    selection <- subset(id_geo_census, CODE.REG == region)$CODE
    return(selection)
  } else if (!missing(provincia)) {
    stopifnot(missing(region))
    stopifnot(missing(comuna))
    selection <- subset(id_geo_census, CODE.PROV == provincia)$CODE
    return(selection)
  } else if (!missing(comuna)) {
    stopifnot(missing(region))
    stopifnot(missing(provincia))
    selection <- subset(id_geo_census, CODE == comuna)$CODE
    return(selection)
  } else {
    return(id_geo_census$CODE)
  }
} # nocov end
