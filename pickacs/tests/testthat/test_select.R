library(pickacs)
context("Experimental Aggreations - Select")

# Test schema for universe "RelChiUnder18"
cp <- read.csv("child_poverty.csv")

# Prototype for select function, specialized for child poverty
child_poverty <- function(data,
                          universe = "RelChiUnder18",
                          income = NA,
                          family = NA,
                          householder = NA,
                          age = NA) {
    equals <- function(a, b) {
        if (is.na(b)) {
            is.na(a)
        } else {
            a == b
        }
    }

    values <- c(universe = universe,
                income = income,
                family = family,
                householder = householder,
                age = age)

    most_specific <- Position(function(x) !is.na(x), values, right = TRUE)
    super_cats <- Filter(function(x) !is.na(x), values[1:most_specific])
    if (most_specific == length(values)) {
        sub_cats <- c()
    } else {
        sub_cats <- values[(most_specific+1):length(values)]
    }
    cats <- c(super_cats, sub_cats)

    dots = lapply(names(cats), function(x) lazyeval::interp("equals(a, b)", equals = equals, a = as.name(x), b = cats[[x]]))

    df <- dplyr::filter_(data, .dots = dots)
    as.character(df[, c("variable")])
}


test_that("defaults select total for universe", {
    result <- child_poverty(cp)

    expect_is(result, 'character')
    expect_equal(length(result), 1)
    expect_equal(result[1], 'B17006_001')
})
