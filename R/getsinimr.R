#' Get a SINIM variable data in a specific year as a data frame
#' @param var variable code
#' @param year year
#' @param moncorr A logical value indicating the use of monetary correction
#' @return data frame with data for the requested variable over time
#' @export
#' @examples
#' getsinimr(880, 2015)
#' getsinimr(c(880,1023), 2015)
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimr <- function(var, year, moncorr=T) {
  if (!is.numeric(var) | !is.numeric(year)) {
    stop("Variables must be numeric")
  } else {
    values <- parsexml(var, year, moncorr=moncorr)
    colnames(values) <- c("CODE", "MUNICIPALITY", getname(var))
    rownames(values) <- c(1:nrow(values))
    values <- as.data.frame(values, stringsAsFactors = F)
    values[, 3] <- as.numeric(gsub("[A-Za-z]", NA, values[, 3]))
    values[, 1] <- as.character(values[, 1])
    return(values)
  }
}
