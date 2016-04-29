load("data-raw/coded_vars.Rda")

devtools::use_data(coded_vars,
                   internal = TRUE,
                   overwrite = TRUE)
