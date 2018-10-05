#' @importFrom stats complete.cases

callapi <- function(url) {
  resp <- GET(url, add_headers("X-Request-Source" = "r"))
  stop_for_status(resp)
  data <- content(resp, "text", encoding = "UTF-8")
  data <- substr(data, 2, nchar(data))
  return(data)
}

postapi <- function(url, body) {
  resp <- POST(
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
  data <- fromJSON(content(resp, "text"))
  return(data)
}

getyear <- function(year) {
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
    2017
  )
  if (any(is.na(match(year, year_list)))) {
    stop("Year not found in list")
  } else {
    return(match(year, year_list))
  }
}

getid <- function(name) {
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <-
    postapi(
      "http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
      body
    )
  list <- melt(sapply(resp, function(b)
    b$mtro_datos_nombre))
  values <- melt(sapply(resp, function(b)
    b$id_dato))
  list$id <- values$value
  colnames(list) <- c("VARIABLE", "CATEGORY", "VALUE")
  list$VARIABLE <-
    as.vector(lapply(as.character(list$VARIABLE), function(x)
      trimws(x)))
  return(list[complete.cases(match(list$VARIABLE, name)), 3])
}

getname <- function(names) {
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <- postapi(
      "http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
      body
    )
  list <- melt(sapply(resp, function(b)
    b$mtro_datos_nombre))
  values <- melt(sapply(resp, function(b)
    b$id_dato))
  list$id <- values$value
  colnames(list) <- c("VARIABLE", "CATEGORY", "VALUE")
  list$VARIABLE <-
    as.vector(lapply(as.character(list$VARIABLE), function(x)
      trimws(x)))
  return(toupper(unlist(list[complete.cases(match(list$VALUE, names)), 1])))
}

parsexml <- function(var, years, moncorr=T) {
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
    data <- xmlParse(callapi(url))
    columns <- as.numeric(
      xpathApply(
        data,
        "//tei:Table/@tei:ExpandedColumnCount",
        namespaces = c(tei = getDefaultNamespace(data)[[1]]$uri)
      )[[1]][[1]],
      xmlValue
    )
    varxml <- xpathSApply(
      data,
      "//tei:Cell[not(@tei:StyleID)]",
      namespaces = c(tei = getDefaultNamespace(data)[[1]]$uri),
      xmlValue
    )
    values <- t(as.data.frame(split(
      as.character(varxml), ceiling(seq_along(varxml) / columns)
    ), stringsAsFactors = F))
    return(values)
}