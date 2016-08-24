#' Fetch ACS dataset.
#'
#' @param name construction name.
#' @param geo geography definition.
#' @param endyear survey end year.
#' @param span survey span.
#' @return An ACS dataset.
#'
#' @export
fetch_acs_data <- function(name, geo, endyear, span) {
    tables <- constr_tables(name)

    # Look up variables for all tables
    lookups <- lapply(tables,
                      function(x) {
                          acs::acs.lookup(endyear = endyear,
                                          span = span,
                                          dataset = "acs",
                                          table.number = x)
                      })
    lookups <- Reduce(`+`, lookups)

    # Fetch entire data set
    data <- acs.fetch(endyear = lookups@endyear,
                      variable = lookups,
                      geography = geo)

    data
}
