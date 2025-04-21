#' Load Antarctica Boundaries
#'
#' This function loads Antarctica's country boundaries as a simple features (`sf`) object
#' and transforms the projection to EPSG:3031 (Antarctic Polar Stereographic).
#'
#' @return An `sf` object containing the geometry of Antarctica.
#'
#' @import rnaturalearth
#' @importFrom sf st_transform
#'
#' @examples
#' \dontrun{
#' continent <- load_continent()
#' plot(continent)
#' }
#'
#'
#' @author Sebastian Rothaug
#'
#' @export
load_continent <- function() {
  antarctica <- rnaturalearth::ne_countries(continent = "Antarctica",
                                            scale = "medium",
                                            return = "sf")

  # CRS Transformation into the Antarctic EPSG: 3031
  antarctica <- sf::st_transform(antarctica, crs = 3031)

  return(antarctica)
}
