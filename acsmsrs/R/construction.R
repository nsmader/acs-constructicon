constr_exists <- function(full_name) {
    exists(full_name, envir = constr_env)
}

constr_require <- function(full_name) {
    if (!constr_exists(full_name)) {
        stop("No construction available for '", full_name, "'")
    }
}

constr_get <- function(full_name, member = NULL) {
    constr_require(full_name)
    entry <- get(full_name, envir = constr_env)

    if (is.null(member)) {
        entry
    } else {
        entry[[member]]
    }
}

constr_class <- function(full_name) {
    constr_get(full_name, member = "class_name")
}

constr_tables <- function(full_name) {
    constr_get(full_name, member = "tables")
}

construction <- function(name) {
    subclass_name <- constr_class(name)
    structure(list(), class = c(subclass_name, "construction"))
}

