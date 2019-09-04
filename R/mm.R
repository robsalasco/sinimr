#' Return a abbreviated value of the "miles de millones" format
#'
#' @param x Numeric value to convert
#'
#' @return A character value in short format
#' @export
#'
#' @examples 
#' mm(5807587000)
mm <- function(x) {
  y <- paste0(formatC(x/1e9, digits = 0, format = "f"), " mm$")
  return(y)
}