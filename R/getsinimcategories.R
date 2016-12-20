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
    resp <- postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php", body)
    list <- melt(sapply(resp, function(b) b$mtro_datos_nombre))
    values <- melt(sapply(resp, function(b) b$id_dato))
    list$id <- values$value
    colnames(list) <- c("VARIABLE", "CATEGORY","VALUE")
    list$VARIABLE <- as.vector(lapply(as.character(list$VARIABLE), function(x) trimws(x)))
    return(unique(list$CATEGORY))
}