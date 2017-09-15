#' Get data for a variable by multiple years as a dataframe 
#' @param variable variable type
#' @param years year id
#' @return data frame with data for the requested variable over time
#' @export
#' @examples
#' getsinimr(880, c(2015,2014,2013))
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimryears <- function(var, years) {
  if ((class(var) != "numeric") | (class(years) != "numeric") | (length(years)<2)) {
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
      id = c("CODIGO", "MUNICIPIO"),
      variable.name = "YEAR",
      value.name = "VALUE",
      factorsAsStrings = T
    ))
  }
}