library(acs)
library(pickacs)

constr <- "Child Poverty"
geo <- geo.make(state = "IL", county = "Cook", tract = "*") 
endyear <- 2013
span <- 5

cp_data <- fetch_acs_data(geo, endyear, span, constr)

devtools::use_data(cp_data, file = "data/child_poverty_cook_2013_5yr.Rda")
