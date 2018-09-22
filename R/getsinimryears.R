#' Get data for a variable by multiple years as a data frame
#' @param var variable code
#' @param years years
#' @return data frame with data for the requested variable over time
#' @export
#' @examples
#' getsinimr(880, c(2015,2014,2013))
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimryears <- function(var, years) {
  if (!is.numeric(var) | !is.numeric(years) | (length(years) < 2)) {
    stop("Variables must be numeric or you have to add more years to retrieve information")
  } else {
    list <- lapply(years, function(x)
      getsinimrbyyear(var, x))
    list <- Reduce(function(x, y)
      merge(x, y, all = TRUE), list)
    list[, 3:ncol(list)] <-
      apply(list[, 3:ncol(list)], 2, function(x)
        as.numeric(as.character(x)))
    return(melt(
      list,
      id = c("CODE", "MUNICIPALITY"),
      variable.name = "YEAR",
      value.name = "CODE",
      factorsAsStrings = T
    ))
  }
}
