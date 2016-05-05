load("data-raw/coded_data.Rda")
load("data-raw/constr_lookup.Rda")

devtools::use_data(coded_data,
                   constr_lookup,
                   internal = TRUE,
                   overwrite = TRUE)
