register.child_poverty <- function(obj) {
    constr_register("Child Poverty",
                    class_name = "child_poverty",
                    tables = "B17006")
}

measure.child_poverty <- function(constr) {
    message("Constructing ", constr$name, " measures")

    new_data <- compute_measure(orig_data = constr$data)

    constr$data <- cbind(constr$data, new_data)

    constr
}

compute_measure <- function(orig_data) {
    # /!\ Consider creating additional age categories, like Age 5 and
    # younger by adding the lt5 and 5 counts

    # Create variables of interest by summing across unused cross-tabs
    data <- data.frame(row.names = rownames(orig_data))
    for (age in c("ALt5", "A5", "A6to17")) {
        for (level in c("IncPrev12moLtPov", "IncPrev12moGePov")) {
            # Add across family types to get all youth in given poverty situation
            data[code(level, age)] <-
                orig_data[, code(level, "FamMar", age)] +
                orig_data[, code(level, "FamOth", "HhGmNWife", age)] +
                orig_data[, code(level, "FamOth", "HhGfNHus", age)]
        }

        # Add across poverty types to get all youth with measured poverty status
        data[code("IncPrev12mo", age)] <-
            data[, code("IncPrev12moLtPov", age)] +
            data[, code("IncPrev12moGePov", age)]
    }

    # Construct desired measures
    out_data <- data.frame(row.names = row.names(data))
    for (age in c("ALt5", "A5", "A6to17")) {
        out_data[code("nPov", age)] <- data[, code("IncPrev12moLtPov", age)]
        out_data[code("wPov", age)] <- data[, code("IncPrev12mo", age)]
        out_data[code("rPov", age)] <-
            out_data[, code("nPov", age)] / out_data[, code("wPov", age)]
    }

    out_data
}
