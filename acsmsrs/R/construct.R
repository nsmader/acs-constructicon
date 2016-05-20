# Create state-country-tract geo IDs from acs package geography info.
geo_ids <- function(geo) {
    assertthat::assert_that(is.data.frame(geo))

    paste0(sprintf("%02d", geo$state),
           sprintf("%03d", geo$county),
           geo$tract)
}

unique_tables <- function(columns) {
    unique(sapply(stringr::str_split(columns, "_"), function(x) x [[1]]))
}

survey <- function(end_year, span) {
    get(paste("codes", end_year, span, sep = "_"))
}

# Given a list of variables and associate survey end year and span,
# return a corresponding list of coded labels.
coded_variables <- function(end_year, span, acs_colnames) {
    tables <- unique_tables(acs_colnames)

    # Combine all data frames for these tables
    survey <- survey(2013, 1)
    data <- Reduce(rbind, survey[tables])

    # Match coded column names
    matches <- merge(data.frame(id = acs_colnames),
                     data,
                     by = "id",
                     all.x = TRUE)

    # Generate codes vector
    codes <- matches$code
    names(codes) <- matches$id

    codes
}

# Convert an acs package dataset to a data frame
convert_acs_data <- function(data) {
    assertthat::assert_that(acs::is.acs(data))

    # Convert ACS matrix to a data frame
    df <- data.frame(data@estimate, row.names = NULL)

    # Rename columns based on coded variable names
    coded_columns <- coded_variables(data@endyear, data@span, data@acs.colnames)
    colnames(df) <- coded_columns

    # Add geocode and tract variables
    df$geo_id <- geo_ids(data@geography)
    df$tract <- data@geography$tract

    df
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
    assertthat::assert_that(assertthat::is.string(name))
    assertthat::assert_that(acs::is.acs(data))

    constr <- construction(name)
    constr$name <- name

    # Load data
    constr$endyear <- data@endyear
    constr$data <- convert_acs_data(data)

    # Apply generic construction method
    constr <- measure(constr)

    constr
}
