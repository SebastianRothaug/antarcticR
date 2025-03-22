#' load_country_boundary
#'
#' #Load the boundary of a specific country from a map object
#' #This function extracts the boundary geometry of a specific country from a map
#' #object and returns it
#'
#'
#' @param map A spatial object containing country boundaries, such as a 'sf' object
#' @param country_name The name of the country whose boundary is to be loaded
#'
#' @return
#' @export
#'
#' @examples
#' library(sf)
#' map <- ne_download(scale = 10, returnclass = "sf")
#' country_boundary <- load_country_boundary(map, "Denmark")
#' plot(country_boundary)
#'
#' @importFrom sdmpredictors load_layers
#' @importFrom raster projectRaster
#'
#' @export
#'
load_sea_ice <- function(season) {

  if (season == "summer") {
    iceMap <- sdmpredictors::load_layers("BO21_icethickltmin_ss")
  }
  else if (season == "winter") {
    iceMap <- sdmpredictors::load_layers("BO21_icethickltmax_ss")
  }
  else {
    stop("Invalid season. Choose either 'summer' or 'winter'.")
  }
  cExtent <- c(-180,180,-90,-45)
  iceMap <- crop(iceMap,cExtent)
  iceMap <- raster::projectRaster(iceMap, crs = "epsg:3031")

  return(iceMap)
}


###
summer_ice <- load_sea_ice("winter")


plot(summer_ice)
