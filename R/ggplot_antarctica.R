




ggplot() +
  # Plot the minimum ice map in red
  geom_raster(data = load_sea_ice("summer"), aes(x = x, y = y, fill = ice_thickness)) +  # Use the correct column name
  scale_fill_gradient(low = "white", high = "red") +  # Color scale for the raster
  # Plot the maximum ice map in blue
  geom_raster(data = load_sea_ice("winter"), aes(x = x, y = y, fill = ice_thickness), alpha = 0.5) +  # Use the correct column name
  scale_fill_gradient(low = "white", high = "blue") +  # Color scale for the raster
  # Plot Antarctica in white (assuming Antarctica_repo is a vector object, use geom_sf)
  geom_sf(data = load_antarctica(), fill = "green", color = "green", size = 0.5) +
  # Customize the plot
  theme_minimal() +
  theme(legend.position = "none") +
  labs(title = "Ice Map Min (Red), Ice Map Max (Blue), Antarctica (White)")
