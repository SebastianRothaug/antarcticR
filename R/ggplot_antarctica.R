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

  ### Summer Season ###
  if (season == "summer") {

    ## Dummy-Data for the legend (not vissible in the plot)
    legend_data <- data.frame(
      x = c(0, 0),
      y = c(0, 0),
      type = c("Continent", "Ice Shelves")
    )

    # ggplot definition
    season_plot <- ggplot2::ggplot() +

      ## Dummy-Elements only for the legend (not vissible in the plot)
      ggplot2::geom_point(data = legend_data,
                          ggplot2::aes(x = x, y = y, shape = type, color = type), size = 4) +
      ggplot2::scale_color_manual(name = "Antarctic",
                                  values = c("Continent" = "#e7ded9", "Ice Shelves" = "#c9f0ff")) +
      ggplot2::scale_shape_manual(name = "Antarctic",
                                  values = c("Continent" = 15, "Ice Shelves" = 15)) + # Square symbols


      # Sea Ice
      ggplot2::geom_raster(data = antarcticR::load_sea_ice("summer"),
                           ggplot2::aes(x = x, y = y, fill = ice_thickness)) +
      # continious fill of the Sea Ice
      ggplot2::scale_fill_gradient(name = "Sea Ice", low = "white", high = "blue") +

      # Continent
      ggplot2::geom_sf(data = antarcticR::load_continent(),
                       fill = "#e7ded9", color = "#e7ded9", size = 0.5, show.legend = FALSE) +
      # Ice Shelves
      ggplot2::geom_sf(data = antarcticR::load_ice_shelves(),
                       fill = "#c9f0ff", color = "#c9f0ff", size = 0.5, show.legend = FALSE) +
      # Coastline
      ggplot2::geom_sf(data = antarcticR::load_antarctic_coastline(),
                       fill = "gray", color = "gray", size = 0.5, show.legend = FALSE) +

      # ggplot theme
      ggplot2::theme_minimal() +
      # title
      ggplot2::labs(title = "Antarctic Summer")
  }


  ### Winter Season ###
  else if (season == "winter") {
    ## Dummy-Data for the legend (not vissible in the plot)
    legend_data <- data.frame(
      x = c(0, 0),
      y = c(0, 0),
      type = c("Continent", "Ice Shelves")
    )

    # ggplot definition
    season_plot <- ggplot2::ggplot() +

      ## Dummy-Elements only for the legend (not vissible in the plot)
      ggplot2::geom_point(data = legend_data,
                          ggplot2::aes(x = x, y = y, shape = type, color = type), size = 4) +
      ggplot2::scale_color_manual(name = "Antarctic",
                                  values = c("Continent" = "#e7ded9", "Ice Shelves" = "#c9f0ff")) +
      ggplot2::scale_shape_manual(name = "Antarctic",
                                  values = c("Continent" = 15, "Ice Shelves" = 15)) + # Square symbols


      # Sea Ice
      ggplot2::geom_raster(data = antarcticR::load_sea_ice("winter"),
                           ggplot2::aes(x = x, y = y, fill = ice_thickness)) +
      # continious fill of the Sea Ice
      ggplot2::scale_fill_gradient(name = "Sea Ice", low = "white", high = "blue") +

      # Continent
      ggplot2::geom_sf(data = antarcticR::load_continent(),
                       fill = "#e7ded9", color = "#e7ded9", size = 0.5, show.legend = FALSE) +
      # Ice Shelves
      ggplot2::geom_sf(data = antarcticR::load_ice_shelves(),
                       fill = "#c9f0ff", color = "#c9f0ff", size = 0.5, show.legend = FALSE) +
      # Coastline
      ggplot2::geom_sf(data = antarcticR::load_antarctic_coastline(),
                       fill = "gray", color = "gray", size = 0.5, show.legend = FALSE) +

      # ggplot theme
      ggplot2::theme_minimal() +
      # title
      ggplot2::labs(title = "Antarctic Winter")
  }

  else {
    stop("Invalid season for plot. Choose either 'summer' or 'winter'.") # Invalid Input
  }

  return(season_plot) # return statement
}










