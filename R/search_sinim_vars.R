#' Search for a SINIM variable and if no keyword is provided returns all variables
#' @param keyword keyword
#' @return data frame with results 
#' @export
#' @examples
#' search_sinim_vars("ingresos propios")

search_sinim_vars <- function(keyword) {
    
  
    body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
    resp2 <- postapi("https://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php",
            body)
    data <- Reduce(function(...) merge(..., all=T), resp2)
    data <- data[ ,c(8, 10, 18, 2, 4, 5)]
    colnames(data) <- c("code", "variable", "description", "area", "subarea", "unit")
    
    if (missing(keyword)) {
      search <- data
    } 
    else {
      stopifnot(is.character(keyword))
      search <- data[with(data, grepl(keyword, paste(variable, description, area, subarea), ignore.case = T)), ]
    }
    
    return(search)
}
