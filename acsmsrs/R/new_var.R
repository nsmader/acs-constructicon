#' Create a new variable code
#'
#' @param strs character vector
#' @return The full variable name (e.g., "nPov_A6to17")
#'
#' @examples
#' new_var(c("nPov", "A6to17"))
#'
#' @export
new_var <- function(strs) {
    code(strs, check = FALSE)
}
