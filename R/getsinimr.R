#' Get a SINIM variable data in a specific year as a data frame
#' @param var variable code
#' @param year year
#' @param moncorr A logical value indicating the use of monetary correction
#' @return data frame with data for the requested variable over time
#' @export
#' @examples
#' getsinimr(880, 2015)
#' getsinimr(880, 2015:2017)
#' getsinimr(c(880, 882), 2015)
#' getsinimr(c(880, 882), 2015:2017)
#' @import httr
#' @importFrom jsonlite fromJSON serializeJSON
#' @import XML
#' @import reshape2

getsinimr <- function(var, year, moncorr=T) {
  
  stopifnot(is.numeric(var))
  stopifnot(is.numeric(year))
  
  values <- parsexml(var, year, moncorr=moncorr)
  
  colnames(values) <- c("CODE","MUNICIPALITY", namesco(var, year))
  
  datav <- reshape(values, 
                   idvar = c("CODE","MUNICIPALITY"),
                   varying = namesco(var, year),
                   v.names = getname(var), 
                   direction = "long",
                   timevar = "YEAR",
                   times=year)
  
  rownames(datav) <- NULL
  
  datav <- melt(datav,id=c("CODE", "MUNICIPALITY","YEAR"),
                value.name="VALUE",
                variable.name = "VARIABLE") 
  datav[, 5] <- as.numeric(gsub("[A-Za-z]", NA, datav[, 5]))
  
  return(datav)
}
