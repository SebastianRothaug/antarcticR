#' Plot Antarctic Sea Ice for a Given Season
#'
#' This function generates a map of Antarctic sea ice extent for either the summer or winter season.
#' It visualizes the seasonal minimum (summer) and maximum (winter) ice thickness.
#'
#' @param season A string indicating the season. Accepts `"summer"` or `"winter"`.
#' @return A `ggplot` object displaying Antarctic sea ice extent for the given season.
#'
#' @details
#' - Summer ice extent (minimum) is shown in **red**.
#' - Winter ice extent (maximum) is shown in **blue**.
#' - The Antarctic continent is displayed in **gray**.
#'
#' @import ggplot2
#'
#' @examples
#' \dontrun{
#' plot_season("summer")
#' plot_season("winter")
#' }
#'
#' @seealso \code{\link{load_sea_ice}}, \code{\link{load_continent}}
#'
#' @author Sebastian Rothaug
#' @export



plot_season <- function(season) {

  if (season == "summer") {
    # Dummy-Data für Legende
    legend_data <- data.frame(
      x = c(0, 0),
      y = c(0, 0),
      type = c("Continent", "Coastline")
    )

    season_plot <- ggplot2::ggplot() +

      # Dummy-Elemente nur für Legende mit `shape` + `color`
      ggplot2::geom_point(data = legend_data,
                          ggplot2::aes(x = x, y = y, shape = type, color = type), size = 4) +

      ggplot2::scale_color_manual(name = "Features",
                                  values = c("Continent" = "gray", "Coastline" = "black")) +
      ggplot2::scale_shape_manual(name = "Features",
                                  values = c("Continent" = 15, "Coastline" = 15)) + # Square symbols

      # Sea Ice mit kontinuierlichem Fill
      ggplot2::geom_raster(data = antarcticR::load_sea_ice("summer"),
                           ggplot2::aes(x = x, y = y, fill = ice_thickness)) +
      ggplot2::scale_fill_gradient(name = "Sea Ice", low = "white", high = "blue") +

      # Kontinent & Küstenlinie
      ggplot2::geom_sf(data = antarcticR::load_continent(),
                       fill = "gray", color = "gray", size = 0.5, show.legend = FALSE) +
      ggplot2::geom_sf(data = antarcticR::load_antarctic_coastline(),
                       fill = "black", color = "black", size = 0.5, show.legend = FALSE) +


      ggplot2::theme_minimal() +
      ggplot2::labs(title = "Antarctic Summer")
  }

  else if (season == "winter") {
    # Dummy-Data für Legende
    legend_data <- data.frame(
      x = c(0, 0),
      y = c(0, 0),
      type = c("Continent", "Coastline")
    )

    season_plot <- ggplot2::ggplot() +

      # Dummy-Elemente nur für Legende mit `shape` + `color`
      ggplot2::geom_point(data = legend_data,
                          ggplot2::aes(x = x, y = y, shape = type, color = type), size = 4) +

      ggplot2::scale_color_manual(name = "Features",
                                  values = c("Continent" = "gray", "Coastline" = "black")) +
      ggplot2::scale_shape_manual(name = "Features",
                                  values = c("Continent" = 15, "Coastline" = 15)) + # Square symbols

      # Sea Ice mit kontinuierlichem Fill
      ggplot2::geom_raster(data = antarcticR::load_sea_ice("winter"),
                           ggplot2::aes(x = x, y = y, fill = ice_thickness)) +
      ggplot2::scale_fill_gradient(name = "Sea Ice", low = "white", high = "blue") +

      # Kontinent & Küstenlinie
      ggplot2::geom_sf(data = antarcticR::load_continent(),
                       fill = "gray", color = "gray", size = 0.5, show.legend = FALSE) +
      ggplot2::geom_sf(data = antarcticR::load_antarctic_coastline(),
                       fill = "black", color = "black", size = 0.5, show.legend = FALSE) +


      ggplot2::theme_minimal() +
      ggplot2::labs(title = "Antarctic Winter")
  }

  else {
    stop("Invalid season for plot. Choose either 'summer' or 'winter'.")
  }

  return(season_plot)
}










