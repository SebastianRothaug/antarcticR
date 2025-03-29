#' Load Antarctic Coastline Data
#'
#' This function loads the Antarctic coastline dataset from the package.
#'
#' @return A spatial or simple features (`sf`) object containing the Antarctic coastline.
#'
#' @examples
#' \dontrun{
#' coastline <- load_antarctic_coastline()
#' plot(coastline)
#' }
#'
#' @export
load_antarctic_coastline <- function() {
  data_env <- new.env()

  # Load dataset into the environment
  data("antarctic_coastline", package = "SRpackage", envir = data_env)

  # Retrieve and return the dataset
  return(get("antarctic_coastline", envir = data_env))
}









load_antarctic_coastline <- function() {
  data("antarctic_coastline", package = "SRpackage")
  return(antarctic_coastline)
}


coastline_test <- load_antarctic_coastline()


plot(coastline_test)




# Define URL and destination
url <- "https://download.geoservice.dlr.de/icelines/files/icelines_antarctic_coastline_2018.zip"
destfile <- "data/icelines_antarctic_coastline_2018.zip"

# Download
download.file(url, destfile, mode = "wb")

# Unzip
unzip(destfile, exdir = "data/icelines_antarctic_coastline_2018")

# Load the shapefile
library(sf)
shp_file <- list.files("data/icelines_antarctic_coastline_2018", pattern = "\\.shp$", full.names = TRUE)
antarctic_coastline <- sf::st_read(shp_file)

antarctic_coastline <- sf::st_transform(antarctic_coastline, crs = 3031)


save(antarctic_coastline, file = "data/antarctic_coastline.rda")




# Quick plot
library(ggplot2)
ggplot2::ggplot() +
  geom_sf(data = antarctic_coastline, color = "blue") +
  theme_minimal()
