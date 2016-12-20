#' Get catch data for a region as a dataframe 
#' @param variable variable type
#' @param year year id
#' @return data frame with data for the requested variable over time
#' @export
#' @examples
#' getsinimr(880, 2015)
#' getsinimr(c(880,1023), 2015)
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape

getsinimr <- function(var,year) {
  year <- getyear(year)
  url <- paste("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_municipales.php?area[]=T&subarea[]=T&variables[]=",paste(var,collapse=","),"&periodos[]=",year,"&regiones[]=T&municipios[]=T&corrmon=false", sep = "")
  data <- xmlParse(callapi(url))
  columns <- as.numeric(xpathApply(data, "//tei:Table/@tei:ExpandedColumnCount",namespaces=c(tei=getDefaultNamespace(data)[[1]]$uri))[[1]][[1]],xmlValue)
  varxml <- xpathSApply(data, "//tei:Cell[not(@tei:StyleID)]",namespaces=c(tei=getDefaultNamespace(data)[[1]]$uri),xmlValue)
  values <- t(as.data.frame(split(as.character(varxml),ceiling(seq_along(varxml)/columns))))
  values[which(values == "No Recepcionado")] <- NA
  colnames(values) <- c("CODIGO","MUNICIPIO",getname(var))
  rownames(values) <- c(1:nrow(values))
  return(as.data.frame(values))
}