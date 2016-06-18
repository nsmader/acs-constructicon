library(acsmsrs)
context("Construct")

# Use Child Poverty construction and test data
data("child_poverty_cook_2013_5yr")
good_name <- "Child Poverty"
good_class <- "child_poverty"
good_data <- child_poverty_cook_2013_5yr
good_result <- construct(good_name, good_data)

test_that("unknown construction name stops execution", {
    expect_error(construct("Foo Bar", good_data),
                 "No construction available for 'Foo Bar'")
})

test_that("construct only accepts single string name", {
    expect_error(construct(42, good_data),
                 "Error.*name is not a string")
    expect_error(construct(c("One", "Two"), good_data),
                 "Error.*name is not a string")
})

test_that("construct only accepts acs dataset", {
    expect_error(construct(good_name, data.frame()),
                 "Error.*acs::is.acs.*is not TRUE")
})

test_that("construct generates object with correct class", {
    expect_is(good_result, good_class)
})

test_that("construct_acs_data data is an acs dataset", {
    expect_error(convert_acs_data(data.frame()),
                 "Error.*acs::is.acs.*is not TRUE")
})

test_that("construct_acs_data returns a data frame", {
    result <- convert_acs_data(good_data)
    expect_is(result, "data.frame")
})

test_that("geo_ids geo is data frame", {
    expect_error(geo_ids(42),
                 "Error.*geo is not a data frame")
})

test_that("geo_ids returns a list of strings of same length as input data", {
    result <- geo_ids(good_data@geography)
    expect_is(result, "character")
    expect_equal(nrow(good_data@geography), length(result))
})
