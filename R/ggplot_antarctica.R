



plot_season <- function(season) {

  if (season == "summer") {
  season_plot <- ggplot2::ggplot() +
    # Plot the minimum ice map in red
    ggplot2::geom_raster(data = load_sea_ice("summer"), ggplot2::aes(x = x, y = y, fill = ice_thickness)) +  # Use the correct column name
    ggplot2::scale_fill_gradient(low = "white", high = "red") +  # Color scale for the raster
    # Plot Antarctica in white (assuming Antarctica_repo is a vector object, use geom_sf)
    ggplot2::geom_sf(data = load_antarctica(), fill = "gray", color = "gray", size = 0.5) +
    # Customize the plot
    ggplot2::theme_minimal() +
    ggplot2::theme(legend.position = "none") +
    ggplot2::labs(title = "Ice Map Min (Red), Ice Map Max (Blue), Antarctica (White)")
  }

  if (season == "winter") {
    season_plot <- ggplot2::ggplot() +
      # Plot the minimum ice map in red
      ggplot2::geom_raster(data = load_sea_ice("winter"), ggplot2::aes(x = x, y = y, fill = ice_thickness)) +  # Use the correct column name
      ggplot2::scale_fill_gradient(low = "white", high = "blue") +  # Color scale for the raster
      # Plot Antarctica in white (assuming Antarctica_repo is a vector object, use geom_sf)
      ggplot2::geom_sf(data = load_antarctica(), fill = "gray", color = "gray", size = 0.5) +
      # Customize the plot
      ggplot2::theme_minimal() +
      ggplot2::theme(legend.position = "none") +
      ggplot2::labs(title = "Ice Map Min (Red), Ice Map Max (Blue), Antarctica (White)")
  }

  else {
    stop("Invalid season. Choose either 'summer' or 'winter'.")
  }

  return(season_plot)
}


####
antseason <- plot_season("winter")

antseason
