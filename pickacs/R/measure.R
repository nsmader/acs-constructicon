measure <- function(obj) {
    UseMethod("measure")
}
measure.default <- function(obj) {
    warning("Unknown class: ", class(x))
}
