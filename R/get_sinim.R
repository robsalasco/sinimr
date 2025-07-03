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
#' @param auc A logical value to retrieve only AUC features
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
           auc = F,
           unit = "comunas") {
    stopifnot(is.numeric(var))
    stopifnot(is.numeric(year))
    
    # Download and parse the raw data for the requested variables and years
    values <- parsexml(var, year, moncorr = moncorr)
    
    # Set column names for the parsed data
    colnames(values) <-
      c("code", "municipality", namesco(var, year))
    
    # Reshape the data to long format for easier manipulation
    datav <- stats::reshape(
      values,
      idvar = c("code", "municipality"),
      varying = namesco(var, year),
      direction = "long",
      timevar = "year",
      times = sort(year, decreasing = T)
    )
    
    # Remove row names for clarity
    rownames(datav) <- NULL
    
    # Replace 'No Recepcionado' and 'No Aplica' with NA
    datav <-
      as.data.frame(apply(datav, 2, function(x)
        gsub("No Recepcionado|No Aplica", NA, x)), stringsAsFactors = FALSE)
    
    if (geometry == FALSE) {
      # Melt the data to have one row per variable per year
      datav <- reshape2::melt(
        datav,
        id = c("code", "municipality", "year"),
        value.name = "value",
        variable.name = "variable"
      )
      
      datav$variable <- as.character(datav$variable)
      
      # Identify numeric columns for conversion
      t <-
        vapply(datav, function(x)
          all(grepl("[0-9]+", na.omit(x))), logical(1))
      
      t[1:4] <- c(TRUE, FALSE, FALSE, FALSE)
      datav[t] <- lapply(datav[t], function(x)
        (as.numeric(x)))
      
      # Apply value conversion if requested
      if (truevalue == TRUE) {
        datav$value <- datav$value * 1000
      }
      
      # Subset by region, provincia, or comuna if provided
      if (!missing(region) |
          !missing(provincia) |
          !missing(comuna)) {
        selection <-
          geofilter(region = region,
                    provincia = provincia,
                    comuna = comuna,
                    auc)
        data.selection <- subset(datav, code %in% selection)
        
        # Merge with geographic info if requested
        if (idgeo == T) {
          merged.pretty <-
            merge(data.selection,
                  id_geo_census,
                  by = c("code", "municipality"))
          return(merged.pretty)
        } else {
          return(data.selection)
        }
        
      } else {
        # Merge with geographic info for all data if requested
        if (idgeo == T) {
          merged.pretty <- merge(datav, id_geo_census, by = "code")
          return(merged.pretty)
        } else {
          return(datav)
        }
      }
    } else {
      # Melt the data for geometry output
      datav <- reshape2::melt(
        datav,
        id = c("code", "municipality", "year"),
        value.name = "value",
        variable.name = "variable"
      )
      
      datav$variable <- as.character(datav$variable)
      
      # Identify numeric columns for conversion
      t <-
        vapply(datav, function(x)
          all(grepl("[0-9]+", na.omit(x))), logical(1))
      
      t[1:4] <- c(TRUE, FALSE, FALSE, FALSE)
      datav[t] <- lapply(datav[t], function(x)
        (as.numeric(x)))
      
      # Apply value conversion if requested
      if (truevalue == TRUE) {
        datav$value <- datav$value * 1000
      }
      
      # Subset by region, provincia, or comuna if provided
      if (!missing(region) |
          !missing(provincia) |
          !missing(comuna)) {
        selection <-
          geofilter(region = region,
                    provincia = provincia,
                    comuna = comuna,
                    auc)
        
        data.selection <- subset(datav, code %in% selection)
        
        # Merge with geometry based on the selected unit
        if (unit == "comunas") {
          merged.geo <-
            merge(census_geometry_comunas, data.selection, by = "code")
        } else if (unit == "limites") {
          merged.geo <-
            merge(census_geometry_limites, data.selection, by = "code")
        } else {
          stop("Unit not valid")
        }
        
        # Merge with geographic info if requested
        if (idgeo == T) {
          merged.geo.pretty <-
            merge(merged.geo,
                  id_geo_census,
                  by = c("code", "municipality"))
          return(merged.geo.pretty)
        } else {
          return(merged.geo)
        }
        
      } else {
        # Merge with geometry for all data based on the selected unit
        if (unit == "comunas") {
          merged.geo <-
            merge(census_geometry_comunas, datav, by = "code")
        } else if (unit == "limites") {
          merged.geo <-
            merge(census_geometry_limites, datav, by = "code")
        } else {
          stop("Unit not valid")
        }
        
        # Merge with geographic info if requested
        if (idgeo == T) {
          merged.geo.pretty <- merge(merged.geo, id_geo_census, by = c("code","municipality"))
          return(merged.geo.pretty)
        } else {
          return(merged.geo)
        }
      }
    }
  }
