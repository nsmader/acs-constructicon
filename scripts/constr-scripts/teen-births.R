# This script creates child poverty measures using table B13002
# See https://www.socialexplorer.com/data/ACS2012_5yr/metadata/?ds=American+Community+Survey+Tables%3A++2008+--+2012+(5-Year+Estimates)&table=B13002
teenbirths <- function(in_data, geos){
  ### Set up data to work with
  out_data <- subset(in_data,
                     select = colnames(in_data) %in% geos)
  attach(in_data)
  
  ### Create variables of interest by summing across unused cross-tabs
  for (a in c("A15to19", "A20to34", "A35to50")){
    for (b in c("Birth", "NBirth")){
      # Add across marital status to get all woman who did/didn't give birth in
      # a given age range
      assign(paste0("Gf", b, "Prev12mo_", a),
             get(paste0("Gf", b, "Prev12mo_Mar_", a)) +
             get(paste0("Gf", b, "Prev12mo_NMar_", a)))
    }
    # Add across poverty types to get all women in a given age range
    assign(paste0("Gf_", a),
           get(paste0("GfBirthPrev12mo_", a)) +
           get(paste0("GfNBirthPrev12mo_", a)))
  }
  
  ### Construct desired measures
  out_data <- within(out_data, {
    for (a in c("A15to19")){ # , "A20to34", "A35to50"
      assign(paste0("nBirths_", a),
             get(paste0("GfBirthPrev12mo_", a)))
      assign(paste0("wBirths_", a),
             get(paste0("Gf_", a)))
      assign(paste0("rBirths_", a),
             get(paste0("nBirths_", a)) / 
             get(paste0("wBirths_", a)))
    }
    rm(a)
  })
  # /!\ Could additionally construct rates by marital status, or for other ages
  # of women
  
  ### Clean up and output
  detach(in_data)
  return(out_data)
}