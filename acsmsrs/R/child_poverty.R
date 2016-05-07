register.child_poverty <- function(obj) {
    constr_register("Child Poverty",
                    class_name = "child_poverty",
                    tables = "B17006")
}

measure.child_poverty <- function(constr) {
    message("Generating ", constr$name, " measures ...")

    # TODO: measure something :-)

    constr
}
