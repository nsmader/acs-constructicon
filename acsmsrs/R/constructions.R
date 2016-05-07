# Internal environment storing construction information
constr_env <- new.env(parent = emptyenv())

# Adds new construction
constr_register <- function(full_name, class_name, tables) {
    if (constr_exists(full_name)) {
        stop("Construction '", full_name, "' previously registered as '",
             class_name, "'")
    }

    new_entry <- list(
        class_name = class_name,
        tables = tables
    )
       
    assign(full_name, new_entry, envir = constr_env)
}

################################################################################
# Register constructions below

constr_register("Child Poverty",
                class_name = "child_poverty",
                tables = "B17006")
