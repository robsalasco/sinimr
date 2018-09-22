#' Get a SINIM variable data in a specific year as a data frame
#' @param var variable code
#' @param year year
#' @return data frame with data for the requested variable over time
#' @export
#' @examples
#' getsinimr(880, 2015)
#' getsinimr(c(880,1023), 2015)
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimr <- function(var, year) {
  if (!is.numeric(var) | !is.numeric(year)) {
    stop("Variables must be numeric")
  } else {
    year <- getyear(year)
    url <- paste(
      "http://datos.sinim.gov.cl/datos_municipales/obtener_datos_municipales.php?area[]=T&subarea[]=T&variables[]=",
      paste(var, collapse = ","), "&periodos[]=", year, "&regiones[]=T&municipios[]=T&corrmon=1",
      sep = ""
    )
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
    colnames(values) <- c("CODE", "MUNICIPALITY", getname(var))
    rownames(values) <- c(1:nrow(values))
    values <- as.data.frame(values, stringsAsFactors = F)
    values[, 3] <- as.numeric(gsub("[A-Za-z]", NA, values[, 3]))
    values[, 1] <- as.character(values[, 1])
    return(values)
  }
}
