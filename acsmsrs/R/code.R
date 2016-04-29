#' Construct coded name
#'
#' @param strs character vector
#' @return coded variable name
#'
#' @examples
#' code(c("GF", "A20to24"))
#'
#' @export
code <- function(strs) {
    full_name <- paste0(strs, collapse = "_")
    if (!(full_name %in% names(coded_vars))) {
        warning("Could not find matching variable for ", full_name)
        full_name <- NA
    }

    full_name
}
