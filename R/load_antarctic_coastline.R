



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

# Quick plot
library(ggplot2)
ggplot2::ggplot() +
  geom_sf(data = antarctic_coastline, color = "blue") +
  theme_minimal()
