#' Get SINIM data categories
#' @return Returns a data frame with available data in SINIM's webpage
#' @export
#' @examples
#' get_sinim_cats()

get_sinim_cats <- function() {
  body <- list("dato_area[]" = "T")
  resp <- postapi("https://cf-sinimr-proxy.mtnlss.workers.dev/datos_municipales/obtener_datos_filtros.php", body)
  out <- lapply(resp, function(x) data.frame(variable = x$nombre_subarea, code = x$id_subarea))

  return(out)
}
