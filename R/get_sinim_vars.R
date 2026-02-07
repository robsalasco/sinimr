#' List available variables for a category
#' @param catn category number
#' @return data frame with variables and values
#' @export
#' @examples
#' get_sinim_vars(47)

get_sinim_vars <- function(catn) {

  stopifnot(is.numeric(catn))
  stopifnot(catn > 0)

  body <- list("dato_area[]" = "T", "dato_subarea[]" = "T")
  resp <- postapi(
    "https://cf-sinimr-proxy.mtnlss.workers.dev/datos_municipales/obtener_datos_filtros.php",
    body
  )
  list <- Reduce(function(...) merge(..., all = T), resp)
  sub <- as.vector(subset(list, id_subarea == catn, select = c("mtro_datos_nombre", "unidad_medida_simbolo", "id_dato")))
  sub_df <- as.data.frame(sub)
  colnames(sub_df) <- c("variable", "unit", "code")

  stopifnot(nrow(sub_df) > 0)

  return(sub_df)

}
