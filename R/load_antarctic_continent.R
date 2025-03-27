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
#' @author Sebastian Rothaug
#'
#' @export
load_antarctica <- function() {
  antarctica <- rnaturalearth::ne_countries(continent = "Antarctica",
                                            scale = "medium",
                                            return = "sf")

  antarctica <- sf::st_transform(antarctica, crs = 3031)

  return(antarctica)
}
