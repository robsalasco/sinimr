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
#' @importFrom reshape2 melt
#' @importFrom stats reshape


getsinimr <- function(var, year, moncorr=T) {
  
  stopifnot(is.numeric(var))
  stopifnot(is.numeric(year))
  
  values <- parsexml(var, year, moncorr=moncorr)
  
  colnames(values) <- c("CODE","MUNICIPALITY", namesco(var, year))
  
  datav <- stats::reshape(values, 
                   idvar = c("CODE","MUNICIPALITY"),
                   varying = namesco(var, year),
                   direction = "long",
                   timevar = "YEAR",
                   times=sort(year, decreasing = T))
  
  rownames(datav) <- NULL
  
  datav <- reshape2::melt(datav,id=c("CODE", "MUNICIPALITY","YEAR"),
                value.name="VALUE",
                variable.name = "VARIABLE") 
  datav[, 5] <- as.numeric(gsub("[A-Za-z]", NA, datav[, 5]))
  
  return(datav)
}
