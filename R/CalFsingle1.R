getCalF <- function(IceShelf, Year, save_dir) {

  base_url <- "https://download.geoservice.dlr.de/icelines/files/"
  subfolder <- paste0(IceShelf, "/annual/fronts/")
  filename <- paste0(Year, "noQ1_mean-", IceShelf, ".gpkg")
  file_url <- paste0(base_url, subfolder, filename)


  dir.create(save_dir, showWarnings = FALSE, recursive = TRUE)
  destfile <- file.path(save_dir, filename)

  message("Downloading: ", filename)
  download.file(file_url, destfile, mode = "wb")

  message("Reading: ", filename)
  front <- sf::st_read(destfile, quiet = TRUE)

  return(front)
}


front <- getCalF("Abbot1", "2015", save_dir = "data/CalvingFront")

str(front)


ggplot() +
  geom_sf(data = front, color = "blue", size = 1) +
  coord_sf(crs = "EPSG:3031") +  # Antarctic Polar Stereographic
  theme_minimal() +
  labs(title = "Calving Front - Abbot1 (2015)",
       caption = "Data source: DLR Icelines Project") +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.caption = element_text(size = 8)
  )
