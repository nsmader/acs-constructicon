# Update internal package data. Right now this includes coded variables.

source("data-raw/variables.R")

codes_2013_1 <- update_variables_info(2013, 1)

devtools::use_data(codes_2013_1,
                   internal = TRUE,
                   overwrite = TRUE)
