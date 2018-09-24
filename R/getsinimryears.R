#' Get data for a variable by multiple years as a data frame
#' @param var variable code
#' @param years years
#' @param moncorr A logical value indicating the use of monetary correction
#' @return data frame with data for the requested variable over time
#' @export
#' @examples
#' getsinimr(880, c(2015,2014,2013))
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimryears <- function(var, years, moncorr=T) {
  if (!is.numeric(var) | !is.numeric(years) | (length(years) < 2)) {
    stop("Variables must be numeric or you have to add more years to retrieve information")
  } else {
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
    colnames(values) <- c("CODE", "MUNICIPALITY", years)
    rownames(values) <- c(1:nrow(values))
    values <- as.data.frame(values, stringsAsFactors = F)
    values <- melt(
      values,
      id = c("CODE", "MUNICIPALITY"),
      variable.name = "YEAR",
      value.name = getname(var),
      factorsAsStrings = T
    )
    values[, 4] <- as.numeric(gsub("[A-Za-z]", NA, values[, 4]))
    values[, 1] <- as.character(values[, 1])
    return(values)
  }
}


