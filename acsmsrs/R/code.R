#' Construct coded name
#'
#' @param ... character string components of a name.
#' @return The coded variable name.
#'
#' @examples
#' code("GF", "A20to24")
#'
#' @export
code <- function(...) {
    paste(..., sep = "_")
}
