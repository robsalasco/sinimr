#' List available variables for a category
#' @param category category type
#' @return a data frame with variables and values
#' @export
#' @examples
#' getsinimvariables("B. INGRESOS MUNICIPALES (%)")
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimvariables <- function(code_s) {
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <-
    postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
            body) 
  list <- Reduce(function(...) merge(..., all=T), resp)
  sub <-
    as.vector(subset(list, id_subarea == code_s, select = c("mtro_datos_nombre", "unidad_medida_simbolo","id_dato")))
  colnames(sub) <- c("VARIABLE", "UNIT", "CODE")
  if (nrow(sub) == 0) {
    stop("Category not found")
  } else {
    return(sub)
  }
}
    