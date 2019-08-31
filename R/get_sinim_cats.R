#' Get SINIM data categories
#' @return Returns a data frame with available data in SINIM's webpage
#' @export
#' @examples
#' get_sinim_cats()

get_sinim_cats <- function() {
  body <- list("dato_area[]" = "T")
  resp <- postapi("http://datos.sinim.gov.cl/datos_municipales/obtener_datos_filtros.php", body)
  return(lapply(resp, function(x) data.frame(VARIABLE = x$nombre_subarea, CODE = x$id_subarea)))
}
