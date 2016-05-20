# Update internal package data. Right now this includes coded variables.

source("data-raw/variables.R")

# http://www.census.gov/data/developers/data-sets/acs-survey-5-year-data.html
codes_2014_5 <- update_variables_info(2014, 5)
codes_2013_5 <- update_variables_info(2013, 5)
codes_2012_5 <- update_variables_info(2012, 5)
codes_2011_5 <- update_variables_info(2011, 5)
codes_2010_5 <- update_variables_info(2010, 5)
codes_2009_5 <- update_variables_info(2009, 5)

# http://www.census.gov/data/developers/data-sets/acs-survey-1-year-data.html
codes_2014_1 <- update_variables_info(2014, 1)
codes_2013_1 <- update_variables_info(2013, 1)
codes_2012_1 <- update_variables_info(2012, 1)

# http://www.census.gov/data/developers/data-sets/acs-survey-3-year-data.html
codes_2013_3 <- update_variables_info(2013, 3)
codes_2012_3 <- update_variables_info(2012, 3)

devtools::use_data(codes_2014_5,
                   codes_2013_5,
                   codes_2012_5,
                   codes_2011_5,
                   codes_2010_5,
                   codes_2009_5,
                   codes_2014_1,
                   codes_2013_1,
                   codes_2012_1,
                   codes_2013_3,
                   codes_2012_3,
                   internal = TRUE,
                   overwrite = TRUE)
