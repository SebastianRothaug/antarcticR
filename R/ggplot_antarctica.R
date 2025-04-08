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
  season_plot <- ggplot2::ggplot() +
    # Plot the minimum ice map in red
    ggplot2::geom_raster(data = antarcticR::load_sea_ice("summer"), ggplot2::aes(x = x, y = y, fill = ice_thickness)) +  # Use the correct column name
    ggplot2::scale_fill_gradient(low = "white", high = "blue") +  # Color scale for the raster
    # Plot Antarctica in white (assuming Antarctica_repo is a vector object, use geom_sf)
    ggplot2::geom_sf(data = antarcticR::load_continent(), fill = "gray", color = "gray", size = 0.5) +
    # Customize the plot
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::labs(title = "Ice Map (Blue), Antarctica (White)")
  }


  ### else if wichtig
  else if (season == "winter") {
    season_plot <- ggplot2::ggplot() +
      # Plot the minimum ice map in red
      ggplot2::geom_raster(data = antarcticR::load_sea_ice("winter"), ggplot2::aes(x = x, y = y, fill = ice_thickness)) +  # Use the correct column name
      ggplot2::scale_fill_gradient(low = "white", high = "blue") +  # Color scale for the raster
      # Plot Antarctica in white (assuming Antarctica_repo is a vector object, use geom_sf)
      ggplot2::geom_sf(data = antarcticR::load_continent(), fill = "gray", color = "gray", size = 0.5) +
      # Customize the plot
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.position = "none") +
      ggplot2::labs(title = "Ice Map (Blue), Antarctica (White)")
  }

  else {
    stop("Invalid season for plot. Choose either 'summer' or 'winter'.")
  }

  return(season_plot)
}

