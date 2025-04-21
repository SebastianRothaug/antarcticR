#' @title Download and Plot Antarctic Calving Fronts from DLR Icelines
#'
#' @description Downloads and visualizes Antarctic ice shelf calving front shapefiles from the DLR Icelines project for a specified year or all available years.
#'
#' @param IceShelf Character. Name of the Antarctic ice shelf (e.g., "Getz1","GeorgeSouth", "Thwaites1", "Amery").
#' @param Year Optional. Numeric or character. Year to download (e.g., 2019) - The annual data availability is not constant and is individual for each ice shelf. If NULL (default), all available years are downloaded.
#' @param save_dir Character. Directory where files will be saved. If Year is NULL, a subfolder named after the ice shelf will be created.
#'
#' @return A ggplot object showing the calving fronts for the selected ice shelf and year(s).
#'
#' @details
#' When `Year` is not specified, the function scrapes the DLR Icelines server to download and plot all available calving front shapefiles for the given ice shelf.
#' The data are visualized using Antarctic Polar Stereographic projection (EPSG:3031), and the continent is plotted for geographic reference.
#' If the file(s) already exist locally, they will not be downloaded again.
#'
#' @note Requires internet connection and the `rvest`, `sf`, `ggplot2` packages.
#'
#' @import ggplot2
#' @import sf
#' @import rvest
#'
#' @examples
#' \dontrun{
#' getCalF("Getz1")  # Download and plot all available years for Getz1 Ice Shelf
#' getCalF("Wilkins", 2020)  # Download and plot only the year 2020 for Wilkins
#'
#' getCalF(IceShelf = "Wilkins", Year = 2020, save_dir = "PATH to your saving directory")
#' }
#'
#' @author Sebastian Rothaug
#' @export


### Year not speciefied = get all availble years ###
getCalF <- function(IceShelf, Year = NULL, save_dir = ".") {

  base_url <- "https://download.geoservice.dlr.de/icelines/files/"
  subfolder <- paste0(IceShelf, "/annual/fronts/")
  url <- paste0(base_url, subfolder)

  # If Year is NULL -> use/create a subdirectory for the IceShelf
  if (is.null(Year)) {
    message("Year not specified -> Downloading all available years for ", IceShelf)
    save_dir <- file.path(save_dir, IceShelf)
  } else {
    message("Year specified -> Downloading chosen year for ", IceShelf)
  }

  dir.create(save_dir, recursive = TRUE, showWarnings = FALSE)

  # Automatically editing the download path based on the defined informations
  if (is.null(Year)) {
    page <- rvest::read_html(url)
    files <- rvest::html_text(rvest::html_nodes(page, "a"))
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

      front <- sf::st_read(destfile, quiet = TRUE)
      fronts[[file]] <- front
    }

    front_combined <- do.call(rbind, fronts)

    message("Downloaded and combined ", length(fronts), " files.")
    # All availble fronts loaded

    # Get a bounding box as limitation for the plot
    bbox <- sf::st_bbox(front_combined)

    # expand the bounding box a little (e.g. 10 km = ~20,000 m in EPSG:3031) just for better looking location in the plot later
    expand_km <- 10 * 1000
    bbox_expanded <- bbox
    bbox_expanded["xmin"] <- bbox["xmin"] - expand_km
    bbox_expanded["xmax"] <- bbox["xmax"] + expand_km
    bbox_expanded["ymin"] <- bbox["ymin"] - expand_km
    bbox_expanded["ymax"] <- bbox["ymax"] + expand_km

    # Crop the Ice Shelves and the Continent (loaded from the functions) to the limitated bounding box expansion
    AOI_ice_shelves <- sf::st_crop(antarcticR::load_ice_shelves(), bbox_expanded)
    AOI_continent <- sf::st_crop(antarcticR::load_continent(), bbox_expanded)


    # ggplot definition
    front_combined_plot <- ggplot2::ggplot() +
      # Continent with Legende (aes= legend definition)
      ggplot2::geom_sf(data = AOI_continent, ggplot2::aes(fill = "Antarctic Continental Shelf"), color = "gray", size = 0.5) +
      # Ice Shelf with Legend (aes= legnd definition)
      ggplot2::geom_sf(data = AOI_ice_shelves, ggplot2::aes(fill = "Ice Shelf - reference 2004"), color = "#c9f0ff", size = 0.5) +
      # Calving Fronts coloured regarding date/year
      ggplot2::geom_sf(data = front_combined, ggplot2::aes(color = as.factor(DATE_)), size = 0.8) +

      ggplot2::coord_sf(crs = "EPSG:3031") +
      ggplot2::theme_minimal() +

      # defining the colourscale colors
      ggplot2::scale_color_viridis_d(name = "Year - Calving Front Position") +

      # manual fill scale for the legend
      ggplot2::scale_fill_manual(
        name = "",
        values = c("Antarctic Continental Shelf" = "gray", "Ice Shelf - reference 2004" = "#c9f0ff")
      ) +

      # legend title subtitle
      ggplot2::labs(
        title = paste("Calving Fronts -", IceShelf),
        caption = "Data source: DLR Icelines Project"
      ) +

      # ggplot theme
      ggplot2::theme(
        plot.title = ggplot2::element_text(size = 14, face = "bold"),
        plot.caption = ggplot2::element_text(size = 8),
        legend.title = ggplot2::element_text(size = 10),
        legend.text = ggplot2::element_text(size = 8)
      )


    return(front_combined_plot)
  }



### Year is speciefied = get only this years ###
  else if (!is.null(Year)) {

    # Automatically editing the download path based on the defined informations
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
    front <- sf::st_read(destfile, quiet = TRUE)

    # Get a bounding box as limitation for the plot
    bbox <- sf::st_bbox(front)

    # expand the bounding box a little (e.g. 10 km = ~20,000 m in EPSG:3031) just for better looking location in the plot later
    expand_km <- 20 * 1000
    bbox_expanded <- bbox
    bbox_expanded["xmin"] <- bbox["xmin"] - expand_km
    bbox_expanded["xmax"] <- bbox["xmax"] + expand_km
    bbox_expanded["ymin"] <- bbox["ymin"] - expand_km
    bbox_expanded["ymax"] <- bbox["ymax"] + expand_km

    # Crop the Ice Shelves and the Continent (loaded from the functions) to the limitated bounding box expansion
    AOI_continent <- sf::st_crop(antarcticR::load_continent(), bbox_expanded)
    AOI_ice_shelves <- sf::st_crop(antarcticR::load_ice_shelves(), bbox_expanded)
    date_label <- unique(front$DATE_)[1]


    # ggplot definition
    front_plot <- ggplot2::ggplot() +
      # Continent with Legende (aes= legend definition)
      ggplot2::geom_sf(data = AOI_continent, ggplot2::aes(fill = "Antarctic Continental Shelf"), color = "gray", size = 0.5) +
      # Ice Shelf with Legend (aes= legnd definition)
      ggplot2::geom_sf(data = AOI_ice_shelves, ggplot2::aes(fill = "Ice Shelf - reference 2004"), color = "#c9f0ff", size = 0.5) +
      # Calving Front coloured in red
      ggplot2::geom_sf(data = front,ggplot2::aes(fill = "Calving Front Position"), color = "red", size = 0.8) +

      ggplot2::coord_sf(crs = "EPSG:3031") +
      ggplot2::theme_minimal() +

      # manual fill scale for the legend
      ggplot2::scale_fill_manual(
        name = "",
        values = c("Antarctic Continental Shelf" = "gray", "Ice Shelf - reference 2004" = "#c9f0ff", "Calving Front Position" = "red")
      ) +

      # legend title subtitle
      ggplot2::labs(
        title = paste("Calving Front -", IceShelf, "(", date_label, ")"),
        caption = "Data source: DLR Icelines Project"
      ) +

      # ggplot theme
      ggplot2::theme(
        plot.title = ggplot2::element_text(size = 14, face = "bold"),
        plot.caption = ggplot2::element_text(size = 8)
      )

    return(front_plot)
  }

  else {
    stop("Invalid input.") # Invalid Input message
  }
}

