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
    message("values:")
    print(values)
    most_specific <- Position(function(x) !is.na(x), values, right = TRUE)
    message("most_specific:")
    print(most_specific)
    super_cats <- Filter(function(x) !is.na(x), values[1:most_specific])
    message("super_cats:")
    print(super_cats)
    if (most_specific == length(values)) {
        sub_cats <- c()
    } else {
        sub_cats <- values[(most_specific+1):length(values)]
    }
    message("sub_cats:")
    print(sub_cats)
    cats <- c(super_cats, sub_cats)
    message("cats")
    print(cats)
    message("-----------")

    #if (names(values)[most_specific] == "family" &&
    #    is.na(income)) {
    #    dots = list(~equals(values$universe, universe),
    #                #~equals(values$income, income),
    #                ~equals(values$family, family),
    #                ~equals(values$householder, householder),
    #                ~equals(values$age, age))
    #} else {
        #dots = list(~equals(values[["universe"]], universe),
        #            ~equals(values[["income"]], income),
        #            ~equals(values[["family"]], family),
        #            ~equals(values[["householder"]], householder),
        #            ~equals(values[["age"]], age))
        #dots = lapply(names(cats), function(x) interp(~equals(a, b), a = as.name(x), b = cats[[x]]))
        dots = lapply(names(cats), function(x) interp("equals(a, b)", equals = equals, a = as.name(x), b = cats[[x]]))
        #return(dots)
        print(dots)
    #}

    df <- filter_(data, .dots = dots)
    as.character(df[, c("variable")])
}

################################################################################

cp <- read.csv("data/child_poverty.csv")

# acs_sum(universe == RelChiUnder18)
#relChiUnder18 <- cp %>%
    #filter(universe == "RelChiUnder18",
    #       is.na(income),
    #       is.na(family),
    #       is.na(householder),
    #       is.na(age)) %>%
#    filter(equals(universe, "RelChiUnder18"),
#           equals(income, NA),
#           equals(family, NA),
#           equals(householder, NA),
#           equals(age, NA)) %>%
#    select(variable)
#relChiUnder18 <- as.character(relChiUnder18[, c("variable")])
#relChiUnder18 <- cp %>% child_poverty()
#assert_that(relChiUnder18 == "B17006_001")
assert_that(all(child_poverty(cp) == "B17006_001"))

# acs_sum(universe == RelChiUnder18,
#         income < poverty)
#incPrev12MoLtPov <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           is.na(family),
#           is.na(householder),
#           is.na(age)) %>%
#    select(variable)
#incPrev12MoLtPov <- as.character(incPrev12MoLtPov[, c("variable")])
incPrev12MoLtPov <- child_poverty(cp, income = "IncPrev12MoLtPov")
assert_that(incPrev12MoLtPov == "B17006_002")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == FamMar)
#famMar <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           family == "FamMar",
#           is.na(householder),
#           is.na(age)) %>%
#    select(variable)
#famMar <- as.character(famMar[, c("variable")])
famMar <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "FamMar")
assert_that(famMar == "B17006_003")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == FamMar,
#         age == ALt5)
#aLt5 <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           family == "FamMar",
#           is.na(householder),
#           age == "ALt5") %>%
#    select(variable)
#aLt5 <- as.character(aLt5[, c("variable")])
aLt5 <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "FamMar",
                  age = "ALt5")
assert_that(aLt5 == "B17006_004")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == FamMar,
#         age == A5)
#a5 <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           family == "FamMar",
#           is.na(householder),
#           age == "A5") %>%
#    select(variable)
#a5 <- as.character(a5[, c("variable")])
a5 <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "FamMar",
                  age = "A5")
assert_that(a5 == "B17006_005")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == FamMar,
#         age == A6to17)
#a6to17 <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           family == "FamMar",
#           is.na(householder),
#           age == "A6to17") %>%
#    select(variable)
#a6to17 <- as.character(a6to17[, c("variable")])
a6to17 <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "FamMar",
                  age = "A6to17")
assert_that(a6to17 == "B17006_006")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == OthFam)
#othFam <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           family == "OthFam",
#           is.na(householder),
#           is.na(age)) %>%
#    select(variable)
#othFam <- as.character(othFam[, c("variable")])
othFam <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "OthFam")
assert_that(othFam == "B17006_007")

# acs_sum(universe == RelChiUnder18,
#         income < poverty,
#         family == OthFam,
#         householder == HhGmNWife)
#ex <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           family == "OthFam",
#           householder == "HhGmNWife",
#           is.na(age)) %>%
#    select(variable)
#ex <- as.character(ex[, c("variable")])
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
#ex <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           family == "OthFam",
#           householder == "HhGmNWife",
#           age == "ALt5") %>%
#    select(variable)
#ex <- as.character(ex[, c("variable")])
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
#ex <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           family == "OthFam",
#           householder == "HhGfNHus",
#           is.na(age)) %>%
#    select(variable)
#ex <- as.character(ex[, c("variable")])
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
#ex <- cp %>%
#    filter(universe == "RelChiUnder18",
#           income == "IncPrev12MoLtPov",
#           family == "OthFam",
#           householder == "HhGfNHus",
#           age == "ALt5") %>%
#    select(variable)
#ex <- as.character(ex[, c("variable")])
ex <- cp %>%
    child_poverty(income = "IncPrev12MoLtPov",
                  family = "OthFam",
                  householder = "HhGfNHus",
                  age = "ALt5")
assert_that(ex == "B17006_013")

# acs_sum(universe == RelChiUnder18,
#         family == FamMar)
#ex <- cp %>%
#    filter(universe == "RelChiUnder18",
#           # income
#           family == "FamMar",
#           is.na(householder),
#           is.na(age)) %>%
#    select(variable)
#ex <- as.character(ex[, c("variable")])
relChiUnder18_FamMar <- cp %>%
    child_poverty(family = "FamMar")
assert_that(any(relChiUnder18_FamMar == c("B17006_003", "B17006_017")))

# acs_sum(universe == RelChiUnder18,
#         family == FamMar,
#         age == ALt5)
ex <- cp %>%
    filter(universe == "RelChiUnder18",
           # income
           family == "FamMar",
           is.na(householder),
           age == "ALt5") %>%
    select(variable)
ex <- as.character(ex[, c("variable")])
assert_that(all(ex == c("B17006_004", "B17006_018")))

# acs_sum(universe == RelChiUnder18,
#         householder == HhGmNWife)
ex <- cp %>%
    filter(universe == "RelChiUnder18",
           # income
           # family
           householder == "HhGmNWife",
           is.na(age)) %>%
    select(variable)
ex <- as.character(ex[, c("variable")])
assert_that(all(ex == c("B17006_008", "B17006_022")))

# acs_sum(universe == RelChiUnder18,
#         age == ALt5)
ex <- cp %>%
    filter(universe == "RelChiUnder18",
           # income
           # family
           # householder
           age == "ALt5") %>%
    select(variable)
ex <- as.character(ex[, c("variable")])
assert_that(all(ex == c("B17006_004", "B17006_009", "B17006_013",
                        "B17006_018", "B17006_023", "B17006_027")))
