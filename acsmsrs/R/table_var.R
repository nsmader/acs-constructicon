# Uncompress year ranges
expand_years <- function(coded_value) {
    years <- rep(NA, 6)
    names(years) <- as.character(seq(2009,2014))

    for (year in names(coded_value)) {
        years[[year]] <- coded_value[[year]]
    }

    last <- NA
    for (year in names(years)) {
        if (is.na(years[[year]])) {
            years[[year]] <- last
        } else {
            last <- years[[year]]
        }
    }

    years
}

#' Retrieve table variable given coded name
#'
#' @param strs character vector.
#' @param end_year end year of survey.
#' @param table table name.
#' @return The full variable name (e.g., "B17006_004").
#'
#' @examples
#' table_var(c("SubSahAfr", "Gha"), end_year = 2010, table = "B04001")
#'
#' @export
table_var <- function(strs, end_year, table) {
    coded_name <- code(strs)
    if (is.na(coded_name)) {
        stop("Could not find matching variable for ", coded_name)
    }

    df <- coded_data[coded_data$code == coded_name &
                     coded_data$end_year == end_year &
                     coded_data$table == table, ]
    if (nrow(df) == 0) {
        stop("Could not find table variable for ", coded_name,
             "; check end year and table")
    } else if (nrow(df) > 1) {
        stop("Found multiple matching variables for ", coded_name,
             "; something is wrong with the internal variables data set")
    }
  
    table_var_name <- df$id
    table_var_name
}
