library(assertthat)

equals <- function(a, b) {
    if (is.na(b)) {
        is.na(a)
    } else {
        a == b
    }
}

child_poverty <- function(data,
                          universe = "RelChiUnder18",
                          income = NA,
                          family = NA,
                          householder = NA,
                          age = NA) {
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

    dots = lapply(names(cats), function(x) interp("equals(a, b)", equals = equals, a = as.name(x), b = cats[[x]]))

    df <- filter_(data, .dots = dots)
    as.character(df[, c("variable")])
}

################################################################################

cp <- read.csv("data/child_poverty.csv")

# acs_sum(universe == RelChiUnder18)
assert_that(all(child_poverty(cp) == "B17006_001"))

# acs_sum(universe == RelChiUnder18,
#         income < poverty)
incPrev12MoLtPov <- child_poverty(cp, income = "IncPrev12MoLtPov")
assert_that(incPrev12MoLtPov == "B17006_002")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == FamMar)
famMar <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "FamMar")
assert_that(famMar == "B17006_003")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == FamMar,
#         age == ALt5)
aLt5 <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "FamMar",
                  age = "ALt5")
assert_that(aLt5 == "B17006_004")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == FamMar,
#         age == A5)
a5 <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "FamMar",
                  age = "A5")
assert_that(a5 == "B17006_005")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == FamMar,
#         age == A6to17)
a6to17 <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "FamMar",
                  age = "A6to17")
assert_that(a6to17 == "B17006_006")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == OthFam)
othFam <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "OthFam")
assert_that(othFam == "B17006_007")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == OthFam,
#         householder == HhGmNWife)
ex <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "OthFam",
                  householder = "HhGmNWife")
assert_that(ex == "B17006_008")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == OthFam,
#         householder == HhGmNWife,
#         age == ALt5)
ex <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "OthFam",
                  householder = "HhGmNWife",
                  age = "ALt5")
assert_that(ex == "B17006_009")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == OthFam,
#         householder == HhGfNHus)
ex <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "OthFam",
                  householder = "HhGfNHus")
assert_that(ex == "B17006_012")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == OthFam,
#         householder == HhGfNHus,
#         age == ALt5)
ex <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "OthFam",
                  householder = "HhGfNHus",
                  age = "ALt5")
assert_that(ex == "B17006_013")

# acs_sum(universe == RelChiUnder18,
#         family == FamMar)
relChiUnder18_FamMar <- cp %>%
    child_poverty(family = "FamMar")
assert_that(any(relChiUnder18_FamMar == c("B17006_003", "B17006_017")))

# acs_sum(universe == RelChiUnder18,
#         family == FamMar,
#         age == ALt5)
ex <- cp %>%
    child_poverty(family = "FamMar", age = "ALt5")
assert_that(all(ex == c("B17006_004", "B17006_018")))

# acs_sum(universe == RelChiUnder18,
#         householder == HhGmNWife)
ex <- cp %>%
    child_poverty(householder = "HhGmNWife")
assert_that(all(ex == c("B17006_008", "B17006_022")))

# acs_sum(universe == RelChiUnder18,
#         age == ALt5)
ex <- cp %>%
    child_poverty(age = "ALt5")
assert_that(all(ex == c("B17006_004", "B17006_009", "B17006_013",
                        "B17006_018", "B17006_023", "B17006_027")))
