sample_csv <- read.csv("C:/Users/User/Desktop/SpainData/Spain_GDP.csv")

sample_gpkg <- sf::st_read("C:/Users/User/Desktop/SpainData/Spain_map.gpkg")

usethis::use_data(sample_csv, sample_gpkg, overwrite = TRUE)


## adding dependecies

usethis::use_package("dplyr")

usethis::use_package("ggplot2")

usethis::use_package("sf")


devtools::check()


devtools::use_git_commit("First package version")


