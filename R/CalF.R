#' @title Download and Plot Antarctic Calving Fronts from DLR Icelines
#'
#' @description Downloads and visualizes Antarctic ice shelf calving front shapefiles from the DLR Icelines project for a specified year or all available years.
#'
#' @param IceShelf Character. Name of the Antarctic ice shelf (e.g., "LarsenC", "Ronne", "Amery").
#' @param Year Optional. Numeric or character. Year to download (e.g., 2019). If NULL (default), all available years are downloaded.
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
#' getCalF("Amery")              # Download and plot all available years for Amery Ice Shelf
#' getCalF("LarsenC", 2018)      # Download and plot only the year 2018 for Larsen C
#' }
#'
#' @author Sebastian Rothaug
#' @export


getCalF <- function(IceShelf, Year = NULL, save_dir = ".") {

  base_url <- "https://download.geoservice.dlr.de/icelines/files/"
  subfolder <- paste0(IceShelf, "/annual/fronts/")
  url <- paste0(base_url, subfolder)

  # If Year is NULL → use a subdirectory for the IceShelf
  if (is.null(Year)) {
    message("Year not specified -> Downloading all available years for ", IceShelf)
    save_dir <- file.path(save_dir, IceShelf)
  } else {
    message("Year specified -> Downloading chosen year for ", IceShelf)
  }

  dir.create(save_dir, recursive = TRUE, showWarnings = FALSE)

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

    bbox <- sf::st_bbox(front_combined)
    AOI_continent <- sf::st_crop(load_continent(), bbox)

    front_combined_plot <- ggplot2::ggplot() +
      ggplot2::geom_sf(data = AOI_continent, fill = "gray", color = "gray", size = 0.5) +
      ggplot2::geom_sf(data = front_combined, ggplot2::aes(color = as.factor(DATE_)), size = 0.8) +
      ggplot2::coord_sf(crs = "EPSG:3031") +
      ggplot2::theme_minimal() +
      ggplot2::scale_color_viridis_d(name = "Year") +
      ggplot2::labs(
        title = paste("Calving Front -", IceShelf, "(All Years)"),
        caption = "Data source: DLR Icelines Project"
      ) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(size = 14, face = "bold"),
        plot.caption = ggplot2::element_text(size = 8)
      )

    return(front_combined_plot)
  }

  else if (!is.null(Year)) {
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

    bbox <- sf::st_bbox(front)
    AOI_continent <- sf::st_crop(load_continent(), bbox)
    date_label <- unique(front$DATE_)[1]

    front_plot <- ggplot2::ggplot() +
      ggplot2::geom_sf(data = AOI_continent, fill = "gray", color = "gray", size = 0.5) +
      ggplot2::geom_sf(data = front, color = "red", size = 0.8) +
      ggplot2::coord_sf(crs = "EPSG:3031") +
      ggplot2::theme_minimal() +
      ggplot2::scale_color_viridis_d(name = "Year") +
      ggplot2::labs(
        title = paste("Calving Front -", IceShelf, "(", date_label, ")"),
        caption = "Data source: DLR Icelines Project"
      ) +
      ggplot2::theme(
        plot.title = ggplot2::element_text(size = 14, face = "bold"),
        plot.caption = ggplot2::element_text(size = 8)
      )

    return(front_plot)
  }

  else {
    stop("Invalid input.")
  }
}

