#' Load Antarctic Coastline Data
#'
#' This function loads the Antarctic coastline dataset from the package.
#'
#' @return A spatial or simple features (`sf`) object containing the Antarctic coastline.
#'
#' @examples
#' \dontrun{
#' coastline <- load_antarctic_coastline()
#' plot(coastline)
#' }
#'
#' @export
load_antarctic_coastline <- function() {
  data_env <- new.env()

  # Load dataset into the environment
  data("antarctic_coastline", package = "antarcticR", envir = data_env)

  # Retrieve and return the dataset
  return(get("antarctic_coastline", envir = data_env))
}

