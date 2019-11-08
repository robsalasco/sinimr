#' Return SINIM variable name using their internal codes
#'
#' @param var Variable code
#'
#' @return A vector of requested variable names
#' @export
#' @examples
#' get_sinim_var_name(880)
#' get_sinim_var_name(c(880, 882))
get_sinim_var_name <- function(var) {
  x <- getname(var)
  
  return(x)
}