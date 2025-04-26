# antarcticR
Welcome to antarcticR ! a package that combines different environmental features of the Antarctic, such as ice shelves, antarctic continetal shelf and the seasonal sea ice distribution. 
It has a particular focus on the calving front dynamics along the antarctic coastline. 
The package provides a tool for accessing, analyzing and visualizing spatial data of this remote region, supporting research on ice shelf retreat and polar environmental change.
&nbsp;

*Author: [Sebastian Rothaug](http://students.eagle-science.org/students/students-2024/sebastian/)*

*Contact: sebastian.rothaug@stud-mail.uni-wuerzburg.de*

&nbsp;

## Installation
The package was developed on R version 4.4.1 and alos tested on the latest R version 4.5.0.
&nbsp;
```R
library(remotes)
remotes::install_github("SebastianRothaug/antarcticR")
library(antarcticR)
```
&nbsp;
*When testing the package on the latest R version 4.5.0 it could come to minor difficulties in the installation.
In this case please read the console messages ( potentially manually load `library(terra)` ) before rerun the installation code.*

## Functions
Accessing geospatial data for different environmental features of Antarctica
&nbsp;
```R
load_continent() # access geospatial (sf) data for the Antarctic continental shelf
load_ice_shelves() # access geospatial (sf) data for the Ice Shelves of Antarctica
load_antarctic_coastline() # access geospatial (sf) data for the Antarctic coastline
load_sea_ice('summer') # access geospatial (raster) data for the seasonal Sea Ice thickness and distribution
load_sea_ice('winter')
```
&nbsp;

Combining and Visualizing geospatial data within the Antarctic seasonality
&nbsp;
```R
plot_season('summer')
plot_season('winter')
# output/return is already a plot statement
```
&nbsp;

get Calving Fronts - Function to access, analyze and visualize Antarctic calving front positions. <br>
Tool for annual calving front dynamic and ice shelf retreat analysation.
&nbsp;
```R
getCalF(IceShelf, Year, save_dir)
getCalF('Getz1', 2020, 'PATH to your saving directory') # annual Calving Front position of a particular year (download data + plot)
getCalF('Getz1', save_dir = 'PATH to your saving directory') # all availble annual Calving Front dynamics of the Ice Shelf (download data + plot)
# output/return is already a plot statement (+ download to your directory)
```
&nbsp;
