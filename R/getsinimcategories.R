#' Get SINIM data categories
#' @return Returns a data frame with available data in SINIM's webpage
#' @export
#' @examples
#' getsinimcategories()
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimcategories<- function() {
  body <- list("dato_area[]" = "T")
  resp <-
    postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
            body)
  return(sapply(resp, function(b) b$nombre_subarea))
}