#' Search for a SINIM variable and if no keyword is provided returns all variables
#' @param keyword keyword
#' @return data frame with results 
#' @export
#' @examples
#' searchsinimvar()
#' searchsinimvar("ingresos propios")

searchsinimvar <- function(keyword) {
    
  
    body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
    resp2 <- postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
            body)
    data <- Reduce(function(...) merge(..., all=T), resp2)
    data <- data[ ,c(8, 10, 18, 2, 4, 5)]
    colnames(data) <- c("CODE", "VARIABLE", "DESCRIPTION", "AREA", "SUBAREA", "UNIT")
    
    if (missing(keyword)) {
      search <- data
    } 
    else {
      stopifnot(is.character(keyword))
      search <- data[with(data, grepl(keyword, paste(VARIABLE, DESCRIPTION, AREA, SUBAREA), ignore.case = T)), ]
    }
    
    return(search)
}
