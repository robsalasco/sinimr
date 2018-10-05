#' Get data for a variable by multiple years as a data frame
#' @param var variable code
#' @param years years
#' @param moncorr A logical value indicating the use of monetary correction
#' @return data frame with data for the requested variable over time
#' @export
#' @examples
#' getsinimryears(880, c(2015,2014,2013))
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimryears <- function(var, years, moncorr=T) {
  
  stopifnot(is.numeric(years))
  stopifnot(is.numeric(var))
  stopifnot(length(years) >= 2)
  
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


