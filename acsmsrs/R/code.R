#' Construct coded name
#'
#' @param strs character vector
#' @param year survey year
#' @return coded variable name
#'
#' @examples
#' code(c("Amrs", "LatAm", "Crb", "Wid3"), 2014)
#'
#' @export
code <- function(strs, year) {
    x <- paste0(strs, collapse = "_")
    if (!(x %in% names(acsmsrs_codes[[as.character(year)]]))) {
        warning("Could not find matching variable for ", x,
                " in year ", year)
    }

    x
}
