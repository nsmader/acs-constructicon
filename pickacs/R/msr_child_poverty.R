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
    #data <- data.frame(row.names = rownames(constr$data))
    #for (age in c("ALt5", "A5", "A6to17")) {
    #    for (level in c("IncPrev12moLtPov", "IncPrev12moGePov")) {
    #        # Add across family types to get all youth in given poverty situation
    #        data[code(level, age)] <-
    #            constr$data[, code(level, "FamMar", age)] +
    #            constr$data[, code(level, "FamOth", "HhGmNWife", age)] +
    #            constr$data[, code(level, "FamOth", "HhGfNHus", age)]
    #    }

    #    # Add across poverty types to get all youth with measured poverty status
    #    data[code("IncPrev12mo", age)] <-
    #        data[, code("IncPrev12moLtPov", age)] +
    #        data[, code("IncPrev12moGePov", age)]
    #}

    # Create variables of interest by summing across unused cross-tabs
    IncPrev12moLtPov_ALt5 <- sum(income = "IncPrev12moLtPov", age = "ALt5")
    IncPrev12moGePov_ALt5 <- sum(income = "IncPrev12moGePov", age = "ALt5")
    IncPrev12mo_ALt5 <- IncPrev12moLtPov_ALt5 + IncPrev12moGePov_ALt5

    IncPrev12moLtPov_A5 <- sum(income = "IncPrev12moLtPov", age = "A5")
    IncPrev12moGePov_A5 <- sum(income = "IncPrev12moGePov", age = "A5")
    #IncPrev12mo_A5 <- IncPrev12moLtPov_A5 + IncPrev12moGePov_A5
    IncPrev12mo_A5 <- sum(age = "A5")

    IncPrev12moLtPov_A6to17 <- sum(income = "IncPrev12moLtPov", age = "A6to17")
    IncPrev12moGePov_A6to17 <- sum(income = "IncPrev12moGePov", age = "A6to17")
    IncPrev12mo_A6to17 <- IncPrev12moLtPov_A6to17 + IncPrev12moGePov_A6to17

    # Construct desired measures
    #out_data <- data.frame(row.names = row.names(data))
    #for (age in c("ALt5", "A5", "A6to17")) {
    #    out_data[code("nPov", age)] <- data[, code("IncPrev12moLtPov", age)]
    #    out_data[code("wPov", age)] <- data[, code("IncPrev12mo", age)]
    #    out_data[code("rPov", age)] <-
    #        out_data[, code("nPov", age)] / out_data[, code("wPov", age)]
    #}

    # Construct desired measures
    nPov_ALt5 <- IncPrev12moLtPov_ALt5
    wPov_ALt5 <- IncPrev12mo_ALt5
    rPov_ALt5 <- nPov_ALt5 / wPov_ALt5

    nPov_A5 <- IncPrev12moLtPov_A5
    wPov_A5 <- IncPrev12mo_A5
    #rPov_A5 <- nPov_A5 / wPov_A5
    rPov_A5 <- sum(income = "IncPrev12moLtPov", age = "ALt5") / sum(age = "ALt5")

    # Number of children between 5 an 17 living in poverty
    # Note: one_of() taken from dplyr
    IncPrev12moLtPov_AGt5 <- sum(income = "IncPrev12moLtPov", age = one_of("A5", "A6to17"))
    # Separating select/filter from operation
    # This is our overloaded select function that works over the implicit
    # hierarchical ACS data format. Underneath the covers, this produces a
    # collection of ACS variable names that can be used to do the actual
    # selection of columns from an estimates table.
    vars <- acsmsrs::select(data, income = "IncPrev12moLtPov", age = one_of("A5", "A6to17"))
    # The above created a collection of six columns. Writing out the longhand
    # form of the summation is going to be messy.
    vals <- dplyr::select(data, vars) %>%
        dplyr::mutate(IncPrev12moLtPov_AGt5 =
            IncPrev12moLtPov_FamMar_A5 +
            IncPrev12moLtPov_FamMar_A6to17 +
            IncPrev12moLtPov_FamOth_HhGmNWife_A5 +
            IncPrev12moLtPov_FamOth_HhGmNWife_A6to17 +
            IncPrev12moLtPov_FamOth_HhGfNHus_A5 +
            IncPrev12moLtPov_FamOth_HhGfNHus_A6to17)
    # Actually, that wasn't too bad, if we imagine those expanded names exist
    # for each column.

    # Now, if we assumed there was some special form of those names that
    # followed rules of hierarchy, then couldn't we implement a shorthand
    # like so:
    IncPrev12moLtPov_AGt5 <- msr(~ IncPrev12moLtPov_A5 + IncPrev12moLtPov_A6to17, data)

    # Proportion of children number 18 living in married households
    msr(FamMar / Total)
    # That is cute, but how what would the non-NSE version look like?
    # According to https://cran.r-project.org/web/packages/dplyr/vignettes/nse.html,
    # something like one of these:
    msr_(~ FamMar / Total)
    msr_(quote(FamMar / Total))
    msr_("FamMar / Total")

    # Now, what happens when there are multiple tables in the same data set?
    # We would need to say something about the specific concept for the table.
    msr(RelChiUnder18_FamMar / RelChiUnder18_Total)
    # How can we access this more programmatically?
    fam_mar <- vars(universe = "RelChiUnder18", family = "FamMar")
    total <- vars(universe = "RelChiUnder18")
    msr(fam_mar / total)
    # But, how do we make sure the `total` uses `B17006_001` instead of
    # aggregating over every variable, including the `001` and the other
    # aggregates?
    vars(universe = "RelChiUnder18")
    # The above would first try to match with all other fields NA, and so
    # would select B17006_001.
    vars(income = "IncPrev12MoLtProv")
    # The above would need to first assume universe is "RelChiUnder18",
    # second match with all other fields NA, and so would select
    # B17006_002.
    vars(family = "FamMar")
    # The above would need to first disregard universe and income, second
    # match with all other fields NA, and so would select B17006_003
    vars(householder = "HhGmNWife")
    # The above would need to first disregard universe, income, and family,
    # second, match with all other fields NA, and so would select
    # B17006_008.
    vars(age = "A5")
    # The above would need to first disregard all previous concepts, and so
    # sould select B17006_{005,010,014}.
    # Note: key here is we have to have some notion of scoping of concepts.
    vars(income = "IncPrev12MoLtPov", householder = "HhGmNWife")
    # The above would need to match any value for concepts more genral than
    # the most specific concept in the expression (i.e., householder) and
    # match NA for all concepts less general than householder.

    nPov_A6to17 <- IncPrev12moLtPov_A6to17
    wPov_A6to17 <- IncPrev12mo_A6to17
    rPov_A6to17 <- nPov_A6to17 / wPov_A6to17

    out_data
}
