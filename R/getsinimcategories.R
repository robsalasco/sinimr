#' Get categories of data in SINIM
#' @return data frame with available data
#' @export
#' @examples
#' getsinimcategories()
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape

getsinimcategories<- function() {
    body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
    omg <- postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php", body)
    lista <- melt(sapply(omg, function(b) b$mtro_datos_nombre))
    lista2 <- melt(sapply(omg, function(b) b$id_dato))
    lista$id <- lista2$value
    colnames(lista) <- c("VARIABLE", "CATEGORY","VALUE")
    lista$VARIABLE <- as.vector(lapply(as.character(lista$VARIABLE), function(x) trimws(x)))
    return(unique(lista$CATEGORY))
}