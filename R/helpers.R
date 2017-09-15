callapi <- function(url) {
    resp <- GET(url, add_headers("X-Request-Source" = "r"))
    stop_for_status(resp)
    data <- content(resp, "text", encoding="UTF-8")
    data <- substr(data, 2, nchar(data))
    return(data)
}

postapi <- function(url, body) {
    resp <- POST(url, body=body, add_headers("User-Agent" = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.116 Safari/537.36", "Referer" = "http://datos.sinim.gov.cl/datos_municipales.php", "Host" = "datos.sinim.gov.cl","X-Requested-With" = "XMLHttpRequest"))
    stop_for_status(resp)
    data <- fromJSON(content(resp, "text"))
    return(data)
}

getyear <- function(year) {
    year_list <- c(2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016)
    if(match(year,year_list)== NA) {
      stop("Year not found in list") 
    } else {
      return(match(year,year_list))
    }  
}

getid <- function(name) {
    body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
    resp <- postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php", body)
    list <- melt(sapply(resp, function(b) b$mtro_datos_nombre))
    values <- melt(sapply(resp, function(b) b$id_dato))
    list$id <- values$value
    colnames(list) <- c("VARIABLE", "CATEGORY","VALUE")
    list$VARIABLE <- as.vector(lapply(as.character(list$VARIABLE), function(x) trimws(x)))
    return(list[complete.cases(match(list$VARIABLE, name)),3])
}

getname <- function(names) {
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <- postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php", body)
  list <- melt(sapply(resp, function(b) b$mtro_datos_nombre))
  values <- melt(sapply(resp, function(b) b$id_dato))
  list$id <- values$value
  colnames(list) <- c("VARIABLE", "CATEGORY","VALUE")
  list$VARIABLE <- as.vector(lapply(as.character(list$VARIABLE), function(x) trimws(x)))
  return(toupper(unlist(list[complete.cases(match(list$VALUE, names)),1])))
}

getsinimrbyyear <- function(x,year) {
  data <- getsinimr(x,year)
  colnames(data)[3] <- as.character(year)
  return(data)
}