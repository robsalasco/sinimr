#' List available variables for a category
#' @param category category type
#' @return a data frame with variables and values
#' @export
#' @examples
#' getsinimvariables("B. INGRESOS MUNICIPALES (%)")
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape

getsinimvariables<- function(category_s) {
    body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
    omg <- postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php", body)
    lista <- melt(sapply(omg, function(b) b$mtro_datos_nombre))
    lista2 <- melt(sapply(omg, function(b) b$id_dato))
    lista$id <- lista2$value
    colnames(lista) <- c("VARIABLE", "CATEGORY","VALUE")
    lista$VARIABLE <- as.vector(lapply(as.character(lista$VARIABLE), function(x) trimws(x)))
    sub <- as.vector(subset(lista, CATEGORY == category_s, select= c("VARIABLE","VALUE")))
    return(sub)
}
    