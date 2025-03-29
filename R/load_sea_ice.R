#' Load Sea Ice Data for a Specific Season
#'
#' This function loads and processes sea ice data for either the summer or winter season,
#' crops the data to a specific geographic extent, projects it to the Antarctic Polar Stereographic
#' coordinate reference system (EPSG:3031), and returns it as a data frame suitable for visualization.
#'
#' @param season A string indicating the season. Accepts `"summer"` or `"winter"`.
#'
#' @return A data frame containing the ice thickness data for the specified season. The data frame
#'   will have columns `x`, `y`, and `ice_thickness` representing the spatial coordinates and ice thickness,
#'   respectively.
#'
#' @details
#' - For **summer**, it loads the minimum ice thickness data (`BO21_icethickltmin_ss`).
#' - For **winter**, it loads the maximum ice thickness data (`BO21_icethickltmax_ss`).
#' - The data is cropped to the region between longitudes -180 to 180 and latitudes -90 to -45.
#' - The resulting data is projected to EPSG:3031 (Antarctic Polar Stereographic).
#'
#' @importFrom sdmpredictors load_layers
#' @importFrom terra crop
#' @importFrom raster projectRaster
#' @importFrom raster as.data.frame
#'
#' @examples
#' \dontrun{
#' load_sea_ice("summer")
#' load_sea_ice("winter")
#' }
#'
#' @seealso \code{\link{plot_season}}
#'
#' @author Your Name
#' @export


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
  iceMap <- terra::crop(iceMap,cExtent)
  iceMap <- raster::projectRaster(iceMap, crs = "epsg:3031")
  # Convert raster data to a data frame for ggplot2
  iceMap <- raster::as.data.frame(iceMap, xy = TRUE, na.rm = TRUE)
  # Rename the data column so both season can be requested with the simalar, general column name
  colnames(iceMap)[3] <- "ice_thickness"

  return(iceMap)
}


seaIceSummer <- load_sea_ice("summer")

plot(seaIceSummer)
