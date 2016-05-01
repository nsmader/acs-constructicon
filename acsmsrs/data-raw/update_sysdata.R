load("data-raw/coded_data.Rda")

devtools::use_data(coded_data,
                   internal = TRUE,
                   overwrite = TRUE)
