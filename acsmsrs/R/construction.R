# Internal environment storing construction information
constr_env <- new.env(parent = emptyenv())

# Adds new construction
constr_register <- function(full_name, class_name, tables) {
    if (constr_exists(full_name)) {
        stop("Construction '", full_name, "' previously registered as '",
             class_name, "'")
    }

    # Add entry for new construction
    new_entry <- list(
        class_name = class_name,
        full_name = full_name,
        tables = tables
    )
    assign(full_name, new_entry, envir = constr_env)

    # Add look up entry for new construction
    new_lookup <- c(full_name)
    names(new_lookup) <- c(class_name)
    if (exists("lookups", envir = constr_env)) {
        all_lookups <- get("lookups", envir_constr_env)
    } else {
        all_lookups <- new_lookup
    }
    assign("lookups", all_lookups, envir = constr_env)
}

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

