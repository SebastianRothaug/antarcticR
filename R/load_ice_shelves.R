#' Load Antarctic Ice Shelf Data
#'
#' This function loads the Antarctic Ice Shelf dataset.
#' The data derived from naturalearthdata Download Service, based on the 2003-2004 reference data.
#'
#' @return A spatial or simple features (`sf`) object containing all the Antarctic Ice Shelves.
#'
#' @examples
#' \dontrun{
#' ice_shelves <- load_ice_shelves()
#' plot(ice_shelves)
#' }
#'
#'@author Sebastian Rothaug
#'
#' @export
load_ice_shelves <- function() {
  data_env <- new.env()

  # Load dataset into the environment
  data("antarctic_ice_shelves", package = "antarcticR", envir = data_env)

  # Retrieve and return the dataset
  return(get("antarctic_ice_shelves", envir = data_env))
}
