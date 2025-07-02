#' Chilean administrative divisions 
#'
#' A dataset containing the chilean administrative units.
#'
#' @format A data frame with 345 rows and 7 variables:
#' \describe{
#'   \item{code}{municipality code}
#'   \item{municipality}{municipality name}
#'   \item{code.reg}{region code}
#'   \item{nom.reg}{region name}
#'   \item{code.prov}{province code}
#'   \item{nom.prov}{province name}
#'   \item{auc}{yes/no consolidated urban area}
#' }
#' @source \url{https://www.ine.cl/}
"id_geo_census"

#' Chilean municipalities polygons as simple features 
#'
#' An sf object containing the chilean municipalities.
#'
#' @format A data frame with 345 rows and 2 variables:
#' \describe{
#'   \item{code}{municipality code}
#'   \item{geometry}{municipality geometry}
#' }
#' @source \url{https://www.ine.cl/}
"census_geometry_comunas"

#' Chilean municipalities urban boundaries polygons as simple features 
#'
#' An sf object containing the chilean municipalities urban boundaries.
#'
#' @format A data frame with 220 rows and 2 variables:
#' \describe{
#'   \item{code}{municipality code}
#'   \item{geometry}{municipality geometry}
#' }
#' @source \url{https://www.ine.cl/}
"census_geometry_limites"