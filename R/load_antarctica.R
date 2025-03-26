#'
#' #OLD Load the boundary of a specific country from a map object
#' #OLD This function extracts the boundary geometry of a specific country from a map
#' #OLD object and returns it
#'
#'
#' @param map OLD A spatial object containing country boundaries, such as a 'sf' object
#' @param country_name OLD The name of the country whose boundary is to be loaded
#'
#' @return
#' @export
#'
#' @examples
#' OLD
#' library(sf)
#' map <- ne_download(scale = 10, returnclass = "sf")
#' country_boundary <- load_country_boundary(map, "Denmark")
#' plot(country_boundary)
#'
#' @importFrom rnaturalearth ne_countries
#' @importFrom sf st_transform
#'
#'
#' @export
#'
load_antarctica <- function(region) {

  antarctica <- rnaturalearth::ne_countries(continent ="Antarctica", scale="medium",return="sf")

  antarctica <- sf::st_transform(Antarctica, crs = 3031)

  return(antarctica)
}


####
ant <- load_antarctica()

plot(ant)
