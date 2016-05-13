#' Construct coded name
#'
#' @param strs character vector.
#' @param check logical specifying whether to check the variable code
#' @return The coded variable name.
#'
#' @examples
#' code(c("GF", "A20to24"))
#'
#' @export
code <- function(strs, check = TRUE) {
    full_name <- paste0(strs, collapse = "_")
    if (check && !(full_name %in% coded_data$code)) {
        warning("Could not find matching variable for ", full_name)
        full_name <- NA
    }

    full_name
}
