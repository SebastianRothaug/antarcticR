# antarcticR
Welcome to antarcticR ! a package that combines different environmental features of the Antarctic, such as ice shelves, antarctic continetal shelf and the seasonal sea ice distribution. 
It has a particular focus on the calving front dynamics along the antarctic coastline. 
The package provides a tool for accessing, analyzing and visualizing spatial data of this remote region, supporting research on ice sheet retreat and polar environmental change.
&nbsp;

*Author: [Sebastian Rothaug](http://students.eagle-science.org/students/students-2024/sebastian/)*

*Contact: sebastian.rothaug@stud-mail.uni-wuerzburg.de*

&nbsp;

## Installation
&nbsp;
```R
library(remotes)
remotes::install_github("SebastianRothaug/antarcticR")
library(antarcticR)
```
&nbsp;

## Functions
&nbsp;
```R
# load functions
load_continent() # access geospatial data for the Antarctic continental shelf
load_ice_shelves() # access geospatial data for the Ice Shelves of Antarctica
load_antarctic_coastline() # access geospatial data for the Antarctic coastline
load_sea_ice('summer') or load_sea_ice('winter') # access geospatial data for the seasonal Sea Ice thickness and distribution

# plot function


```
&nbsp;


![Image](https://github.com/user-attachments/assets/1bd51974-9dbd-4b92-9d77-59422f9fd43d)
