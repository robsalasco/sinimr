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

getsinimvariables<- function(category_s) {
  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <-
    postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
            body)
  list <- melt(sapply(resp, function(b)
    b$mtro_datos_nombre))
  values <- melt(sapply(resp, function(b)
    b$id_dato))
  list$id <- values$value
  colnames(list) <- c("VARIABLE", "CATEGORY", "VALUE")
  list$VARIABLE <-
    as.vector(lapply(as.character(list$VARIABLE), function(x)
      trimws(x)))
  sub <-
    as.vector(subset(list, CATEGORY == category_s, select = c("VARIABLE", "VALUE")))
  if (nrow(getsinimvariables(sub)) == 0) {
    stop("Category not found")
  } else {
    return(sub)
  }
}
    