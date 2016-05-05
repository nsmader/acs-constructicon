# Finds construction tables for a given concept
constr_tables <- function(concept) {
    if (!(concept %in% names(constr_lookup))) {
        warning("Could not find construction for ", concept)
    }

    constr_lookup[[concept]]
}
