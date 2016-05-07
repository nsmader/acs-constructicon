# Create state-country-tract geo IDs from acs package geography info.
geo_ids <- function(geo) {
    paste0(sprintf("%02d", geo$state),
           sprintf("%03d", geo$county),
           geo$tract)
}

# Convert an acs package dataset to a data frame
convert_acs_data <- function(data) {
    # Convert ACS matrix to a data frame
    df <- data.frame(data@estimate, row.names = NULL)

    # Add geocode and tract variables
    df$geo_id <- geo_ids(data@geography)
    df$tract <- data@geography$tract
}

#' Construct new measures.
#'
#' @param name construction name.
#' @param data ACS dataset.
#' @return A new construction.
#'
#' @examples
#' construct("Child Poverty", data = acs_data)
#'
#' @export
construct <- function(name, data) {
    constr <- construction(name)
    constr$name <- name

    # Load data
    constr$df <- convert_acs_data(data)

    # Apply generic construction method
    constr <- measure(constr)

    constr
}
