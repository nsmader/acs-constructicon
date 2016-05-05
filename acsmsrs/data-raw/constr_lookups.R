library(jsonlite)

constr_lookup <- fromJSON("data-raw/constr.json")

# Store data for use in package
save(constr_lookup, file = "data-raw/constr_lookup.Rda")
