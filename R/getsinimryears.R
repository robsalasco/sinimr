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
#' @import reshape

getsinimryears <- function(var,years) {
  lista <- lapply(years, function(x) getsinimrbyyear(var,x))
  lista <- Reduce(function(x, y) merge(x, y, all=TRUE), lista)
  lista[,3:ncol(lista)] <- apply(lista[,3:ncol(lista)],2, function(x) as.numeric(as.character(x)))
  return(melt(lista, id=c("CODIGO","MUNICIPIO"),factorsAsStrings=T))
}