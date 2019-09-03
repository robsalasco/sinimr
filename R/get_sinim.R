#' Get a SINIM variable data in a specific year as a data frame
#' @param var Variable code
#' @param year Year
#' @param moncorr A logical value indicating the use of monetary correction
#' @param truevalue A logical value indicating the use of converted values
#' @param idgeo A logical value to add provincia and region columns
#' @param geometry A logical value to add geographical features
#' @param region Region subsetting variable
#' @param provincia Provincia subsetting variable
#' @param comuna Comuna subsetting variable
#' @param unit Use "comunas" or "limites"
#' @return data frame for the requested variable over time with optional geometry
#' @export
#' @examples
#' get_sinim(880, 2015)
#' get_sinim(880, 2015:2017)
#' get_sinim(c(880, 882), 2015)
#' get_sinim(c(880, 882), 2015:2017)
#' get_sinim(c(880, 882), 2015, idgeo=TRUE)
#' get_sinim(882, 2015, geometry=TRUE)
#' get_sinim(882, 2015, region="02")
#' @importFrom reshape2 melt
#' @importFrom stats reshape
#' @importFrom stats na.omit
#' @import sf
#'
get_sinim <-
  function(var,
           year,
           moncorr = T,
           truevalue = F,
           idgeo = F,
           geometry = F,
           region,
           provincia,
           comuna,
           unit = "comunas") {
    stopifnot(is.numeric(var))
    stopifnot(is.numeric(year))
    
    values <- parsexml(var, year, moncorr = moncorr)
    
    colnames(values) <-
      c("CODE", "MUNICIPALITY", namesco(var, year))
    
    datav <- stats::reshape(
      values,
      idvar = c("CODE", "MUNICIPALITY"),
      varying = namesco(var, year),
      direction = "long",
      timevar = "YEAR",
      times = sort(year, decreasing = T)
    )
    
    rownames(datav) <- NULL
    
    datav <-
      as.data.frame(apply(datav, 2, function(x)
        gsub("No Recepcionado|No Aplica", NA, x)), stringsAsFactors = FALSE)
    
    if (geometry == FALSE) {
      datav <- reshape2::melt(
        datav,
        id = c("CODE", "MUNICIPALITY", "YEAR"),
        value.name = "VALUE",
        variable.name = "VARIABLE"
      )
      
      t <-
        vapply(datav, function(x)
          all(grepl("[0-9]+", na.omit(x))), logical(1))
      t[1:3] <- FALSE
      
      if (truevalue == TRUE) {
        datav[t] <- lapply(datav[t], function(x)
          (as.numeric(x)) * 1000)
      } else {
        datav[t] <- lapply(datav[t], function(x)
          (as.numeric(x)))
      }
      
      if (!missing(region) |
          !missing(provincia) |
          !missing(comuna)) {
        selection <-
          geofilter(region = region,
                    provincia = provincia,
                    comuna = comuna)
        data.selection <- subset(datav, CODE %in% selection)
        
        if (idgeo == T) {
          merged.pretty <- merge(data.selection, id_geo_census, by = "CODE")
          return(merged.pretty)
        } else {
          return(data.selection)
        }
        
      } else {
        if (idgeo == T) {
          merged.pretty <- merge(datav, id_geo_census, by = "CODE")
          return(merged.pretty)
        } else {
          return(datav)
        }
      }
    } else {
      t <-
        vapply(datav, function(x)
          all(grepl("[0-9]+", na.omit(x))), logical(1))
      
      t[1:3] <- FALSE
      
      if (truevalue == TRUE) {
        datav[t] <- lapply(datav[t], function(x)
          (as.numeric(x)) * 1000)
      } else {
        datav[t] <- lapply(datav[t], function(x)
          (as.numeric(x)))
      }
      
      if (!missing(region) |
          !missing(provincia) |
          !missing(comuna)) {
        selection <-
          geofilter(region = region,
                    provincia = provincia,
                    comuna = comuna)
        data.reshaped <- reshape2::melt(
          datav,
          id = c("CODE", "MUNICIPALITY", "YEAR"),
          value.name = "VALUE",
          variable.name = "VARIABLE"
        )
        data.selection <- subset(data.reshaped, CODE %in% selection)
        
        if (unit == "comunas") {
          merged.geo <-
            merge(census_geometry_comunas, data.selection, by = "CODE")
        } else if (unit == "limites") {
          merged.geo <-
            merge(census_geometry_limites, data.selection, by = "CODE")
        } else {
          print("Unit not valid")
        }
        
        
        if (idgeo == T) {
          merged.geo.pretty <- merge(merged.geo, id_geo_census, by = "CODE")
          return(merged.geo.pretty)
        } else {
          return(merged.geo)
        }
        
      } else {
        data.reshaped <- reshape2::melt(
          datav,
          id = c("CODE", "MUNICIPALITY", "YEAR"),
          value.name = "VALUE",
          variable.name = "VARIABLE"
        )
        
        if (unit == "comunas") {
          merged.geo <-
            merge(census_geometry_comunas, data.reshaped, by = "CODE")
        } else if (unit == "limites") {
          merged.geo <-
            merge(census_geometry_limites, data.reshaped, by = "CODE")
        } else {
          print("Unit not valid")
        }
        
        
        if (idgeo == T) {
          merged.geo.pretty <- merge(merged.geo, id_geo_census, by = "CODE")
          return(merged.geo.pretty)
        } else {
          return(merged.geo)
        }
      }
    }
  }
