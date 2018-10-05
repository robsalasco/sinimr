#' Search a SINIM variable
#' @param keyword keyword
#' @return data frame with results 
#' @export
#' @examples
#' searchsinimvar("ingresos propios")
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

searchsinimvar <- function(keyword) {
    
    stopifnot(is.character(keyword))
  
    body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
    resp2 <- postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
            body)
    data <- Reduce(function(...) merge(..., all=T), resp2)
    data <- data[ ,c(8, 10, 18, 2, 4, 5)]
    colnames(data) <- c("CODE", "VARIABLE", "DESCRIPTION", "AREA", "SUBAREA", "UNIT")
    search <- data[with(data, grepl(keyword, paste(VARIABLE, DESCRIPTION, AREA, SUBAREA), ignore.case = T)), ]
    return(search)

}
