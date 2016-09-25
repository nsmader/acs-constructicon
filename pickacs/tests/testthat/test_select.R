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

    expect_is(result, "character")
    expect_equal(length(result), 1)
    expect_equal(result[1], "B17006_001")
})

test_that("first level selection works", {
    result <- child_poverty(cp, income = "IncPrev12MoLtPov")

    expect_is(result, "character")
    expect_equal(length(result), 1)
    expect_equal(result[1], "B17006_002")
})

test_that("second level, single branch works", {
    result_FamMar <- child_poverty(cp,
      income = "IncPrev12MoLtPov",
      family = "FamMar"
    )

    expect_is(result_FamMar, "character")
    expect_equal(length(result_FamMar), 1)
    expect_equal(result_FamMar[1], "B17006_003")

    result_OthFam <- child_poverty(cp,
      income = "IncPrev12MoLtPov",
      family = "OthFam"
    )

    expect_is(result_OthFam, "character")
    expect_equal(length(result_OthFam), 1)
    expect_equal(result_OthFam[1], "B17006_007")
})

test_that("third level, single branch works", {
    result_ALt5 <- child_poverty(cp,
      income = "IncPrev12MoLtPov",
      family = "FamMar",
      age = "ALt5"
    )

    expect_is(result_ALt5, "character")
    expect_equal(length(result_ALt5), 1)
    expect_equal(result_ALt5[1], "B17006_004")

    result_A5 <- child_poverty(cp,
      income = "IncPrev12MoLtPov",
      family = "FamMar",
      age = "A5"
    )

    expect_is(result_A5, "character")
    expect_equal(length(result_A5), 1)
    expect_equal(result_A5[1], "B17006_005")

    result_A6to17 <- child_poverty(cp,
      income = "IncPrev12MoLtPov",
      family = "FamMar",
      age = "A6to17"
    )

    expect_is(result_A6to17, "character")
    expect_equal(length(result_A6to17), 1)
    expect_equal(result_A6to17[1], "B17006_006")

    result_OthFam_HhGmNWife <- child_poverty(cp,
      income = "IncPrev12MoLtPov",
      family = "OthFam",
      householder = "HhGmNWife"
    )

    expect_is(result_OthFam_HhGmNWife, "character")
    expect_equal(length(result_OthFam_HhGmNWife), 1)
    expect_equal(result_OthFam_HhGmNWife[1], "B17006_008")
})
