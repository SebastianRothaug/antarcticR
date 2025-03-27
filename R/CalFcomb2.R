getCalF <- function(IceShelf, Year = NULL, save_dir = ".") {

  if (!requireNamespace("rvest", quietly = TRUE)) install.packages("rvest")
  if (!requireNamespace("sf", quietly = TRUE)) install.packages("sf")

  library(rvest)
  library(sf)

  base_url <- "https://download.geoservice.dlr.de/icelines/files/"
  subfolder <- paste0(IceShelf, "/annual/fronts/")
  url <- paste0(base_url, subfolder)

  dir.create(save_dir, recursive = TRUE, showWarnings = FALSE)

  # If Year is NULL → Download all
  if (is.null(Year)) {
    message("Year not specified → Downloading all available years for ", IceShelf)

    # Scrape file list
    page <- read_html(url)
    files <- page %>% html_nodes("a") %>% html_text()
    gpkg_files <- grep("\\.gpkg$", files, value = TRUE)

    fronts <- list()

    for (file in gpkg_files) {
      file_url <- paste0(url, file)
      destfile <- file.path(save_dir, file)

      if (!file.exists(destfile)) {
        message("Downloading: ", file)
        download.file(file_url, destfile, mode = "wb")
      } else {
        message("Already downloaded: ", file)
      }

      front <- st_read(destfile, quiet = TRUE)
      fronts[[file]] <- front
    }

    message("Downloaded ", length(fronts), " files.")
    return(fronts)
  }

  # If Year is specified → Download one file
  filename <- paste0(Year, "noQ1_mean-", IceShelf, ".gpkg")
  file_url <- paste0(url, filename)
  destfile <- file.path(save_dir, filename)

  if (!file.exists(destfile)) {
    message("Downloading: ", filename)
    download.file(file_url, destfile, mode = "wb")
  } else {
    message("Already downloaded: ", filename)
  }

  message("Reading: ", filename)
  front <- st_read(destfile, quiet = TRUE)
  return(front)
}



# Combine list of sf objects into one
front_combined <- do.call(rbind, front)

str(front_combined)

# Plot
ggplot() +
  geom_sf(data = front_combined, aes(color = as.factor(DATE_)), size = 0.8) +
  coord_sf(crs = "EPSG:3031") +  # Antarctic Polar Stereographic
  theme_minimal() +
  scale_color_viridis_d(name = "Year") +
  labs(title = "Calving Front - Abbot1 (All Years)",
       caption = "Data source: DLR Icelines Project") +
  theme(
    plot.title = element_text(size = 14, face = "bold"),
    plot.caption = element_text(size = 8)
  )

