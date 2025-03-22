#' Defines plot limits of the plots / final animation
#'
#' `antarctica` defines the plot limits of the final animation, or any two plots that should have the same limits. Also works for a single plot.
#'
#' @param data_start A geodataframe (sf data.frame)
#' @param data_end A geodataframe (sf data.frame), if not specified data_start
#' @param parameter_w The parameter for the west limit (numeric). Decrease to have larger plot limits.
#' @param parameter_e The parameter for the east limit (numeric). Increase to have larger plot limits.
#' @param parameter_s The parameter for the south limit (numeric). Decrease to have larger plot limits.
#' @param parameter_n The parameter for the north limit (numeric). Increase to have larger plot limits.
#'
#' @return A lists containing two vectors of two values each.
#'
#'
#' @importFrom sf st_bbox
#'
#'
#' @author Anna Bischof, Georg Starz
#'
#' @export

## -------------------------------
## Prepare data
# Load libraries and dependences
library(sdmpredictors)
library(ggplot2)
library(rnaturalearth)
library(raster)
library(terra)
library(sf)
library(stars)

antarcticR <- function(df, col)


## Define the extent of the map
cExtent <- c(-180,180,-90,-45)

bbox_sh <- st_bbox(c(xmin = -180, xmax = 180, ymin = -90, ymax = -45))

# Convert the bounding box into a simple feature object (polygon) with CRS EPSG:4326
sh_sf <- st_as_sfc(bbox_sh, crs = 4326)


str(cExtent)

#View(list_layers())
## Load in Data from sdmpredictors
iceMapMin <- load_layers("BO21_icethickltmin_ss")
## Sea ice concentration (longterm max)
iceMapMax <- load_layers("BO21_icethickltmax_ss")
## Sea ice concentration (mean)
iceMapMean <- load_layers("BO21_icethickmean_ss")

View(iceMapMax_df)

bathymean <- load_layers("BO_bathymean")

plot(bathymean)
## Load Antarctica Continent from natural earth
Antarctica <- ne_countries(continent ="Antarctica", scale="medium",return="sf")
plot(Antarctica)


#iceMapMin <- as_Spatial(st_as_sf(st_as_stars(iceMapMin), as_points = FALSE, merge = TRUE) )
#iceMapMax <- as_Spatial(st_as_sf(st_as_stars(iceMapMax), as_points = FALSE, merge = TRUE) )


## Crop ice data to the final exent
iceMapMin <- crop(iceMapMin,cExtent)
iceMapMax <- crop(iceMapMax,cExtent)

#reprojection
iceMapMin_repo <- projectRaster(iceMapMin, crs = "epsg:3031")
iceMapMax_repo <- projectRaster(iceMapMax, crs = "epsg:3031")
plot(iceMapMax_repo)

iceMapMin_repo

iceMap_diff_repo <- iceMapMax_repo - iceMapMin_repo

plot(iceMap_diff_repo)

Antarctica_repo <- st_transform(Antarctica, crs = 3031)
plot(Antarctica_repo)


str(iceMapMin_repo)


# Convert raster data to a data frame for ggplot2
iceMapMin_df <- as.data.frame(iceMapMin_repo, xy = TRUE, na.rm = TRUE)
iceMapMax_df <- as.data.frame(iceMapMax_repo, xy = TRUE, na.rm = TRUE)
Antarctica_df <- as.data.frame(Antarctica_repo, xy = TRUE, na.rm = TRUE)

## -------------------------------
usethis::use_data(iceMapMin_df,iceMapMax_df, overwrite = TRUE)
## -------------------------------


ggplot() +
  # Plot the minimum ice map in red
  geom_raster(data = load_sea_ice("summer"), aes(x = x, y = y, fill = ice_thickness)) +  # Use the correct column name
  scale_fill_gradient(low = "white", high = "red") +  # Color scale for the raster
  # Plot the maximum ice map in blue
  geom_raster(data = load_sea_ice("winter"), aes(x = x, y = y, fill = ice_thickness), alpha = 0.5) +  # Use the correct column name
  scale_fill_gradient(low = "white", high = "blue") +  # Color scale for the raster
  # Plot Antarctica in white (assuming Antarctica_repo is a vector object, use geom_sf)
  geom_sf(data = Antarctica_repo, fill = "white", color = "white", size = 0.5) +
  # Customize the plot
  theme_minimal() +
  theme(legend.position = "none") +
  labs(title = "Ice Map Min (Red), Ice Map Max (Blue), Antarctica (White)")





# Check the column names of the data frames
colnames(iceMapMin_df)
colnames(iceMapMax_df)

iceMap <- ggplot() +

  geom_polygon(data = iceMapMax, aes(x = long, y = lat, group = group), fill="#BCD9EC", colour = NA) +
  geom_path(data = iceMapMax, aes(x = long, y = lat, group = group), color = "#BCD9EC", size = 0.1) +

  geom_polygon(data = iceMapMin, aes( x = long, y = lat, group = group), fill="#89B2C7", colour = NA) + #89B2C7
  geom_path(data = iceMapMin, aes(x = long, y = lat, group = group), color = "#89B2C7", size = 0.1) +

  geom_polygon(data = worldMap, aes(x = long, y = lat, group = group), fill="#E0DAD5", colour = NA) +

  theme(legend.position = "none") +
  theme(text = element_text(family = "Helvetica", color = "#22211d")) +
  theme(panel.background = element_blank(), axis.ticks=element_blank()) +

  coord_map("ortho", orientation = c(90, 0, 0)) +
  scale_y_continuous(breaks = seq(45, 90, by = 5), labels = NULL) +

  scale_x_continuous(breaks = NULL) + xlab("") +  ylab("") +

  # Adds labels
  geom_text(size=3.5 , aes(x = 180, y = seq(53.3, 83.3, by = 15), hjust = -0.3, label = paste0(seq(55, 85, by = 15), "°N"))) +
  geom_text(size=3.5 , aes(x = x_lines, y = (41 + c(-3,-3,0,-3,-3,0)), label = c("120°W", "60°W", "0°", "60°E", "120°E", "180°W"))) +

  # Adds axes
  geom_hline(aes(yintercept = 45), size = 0.5, colour = "gray")  +
  geom_segment(size = 0.1,aes(y = 45, yend = 90, x = x_lines, xend = x_lines), linetype = "dashed") +

  geom_segment(size = 1.2 ,aes(y = 45, yend = 45, x = -180, xend = 0), colour = "gray") +
  geom_segment(size = 1.2 ,aes(y = 45, yend = 45, x = 180, xend = 0), colour = "gray") +

  geom_segment(size = 0.1 ,aes(y = 55, yend = 55, x = -180, xend = 0), linetype = "dashed") +
  geom_segment(size = 0.1 ,aes(y = 55, yend = 55, x = 180, xend = 0), linetype = "dashed") +

  geom_segment(size = 0.1 ,aes(y = 70, yend = 70, x = -180, xend = 0), linetype = "dashed") +
  geom_segment(size = 0.1 ,aes(y = 70, yend = 70, x = 180, xend = 0), linetype = "dashed") +

  geom_segment(size = 0.1 ,aes(y = 85, yend = 85, x = -180, xend = 0), linetype = "dashed") +
  geom_segment(size = 0.1 ,aes(y = 85, yend = 85, x = 180, xend = 0), linetype = "dashed")

iceMap
