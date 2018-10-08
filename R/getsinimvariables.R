#' List available variables for a category
#' @param catn category number
#' @return data frame with variables and values
#' @export
#' @examples
#' getsinimvariables(47)
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimvariables <- function(catn) {
  
  stopifnot(is.numeric(catn))
  stopifnot(catn > 0)
  
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <- postapi(
    "http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
    body
  )
  list <- Reduce(function(...) merge(..., all = T), resp)
  sub <- as.vector(subset(list, id_subarea == catn, select = c("mtro_datos_nombre", "unidad_medida_simbolo", "id_dato")))
  colnames(sub) <- c("VARIABLE", "UNIT", "CODE")
 
   stopifnot(nrow(sub) > 0)
  
   return(sub)

}
