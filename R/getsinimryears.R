#' Get data for a variable by multiple years as a data frame
#' @param var variable code
#' @param years years
#' @param moncorr A logical value indicating the use of monetary correction
#' @return data frame with data for the requested variable over time
#' @export
#' @examples
#' getsinimr(880, c(2015,2014,2013))
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimryears <- function(var, years, moncorr=T) {
  if (!is.numeric(var) | !is.numeric(years) | (length(years) < 2)) {
    stop("Variables must be numeric or you have to add more years to retrieve information")
  } else {
    values <- parsexml(var, years, moncorr=moncorr)
    colnames(values) <- c("CODE", "MUNICIPALITY", years)
    rownames(values) <- c(1:nrow(values))
    values <- as.data.frame(values, stringsAsFactors = F)
    values <- melt(
      values,
      id = c("CODE", "MUNICIPALITY"),
      variable.name = "YEAR",
      value.name = getname(var),
      factorsAsStrings = T
    )
    values[, 4] <- as.numeric(gsub("[A-Za-z]", NA, values[, 4]))
    values[, 1] <- as.character(values[, 1])
    return(values)
  }
}


