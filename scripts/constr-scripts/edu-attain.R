# This script creates educational attainment measures using table B15001
# See https://www.socialexplorer.com/data/ACS2013_5yr/metadata/?ds=ACS13_5yr&table=B15001
edatt <- function(in_data, geos){
  
  ### Set up data to work with
  out_data <- subset(in_data,
                     select = colnames(in_data) %in% geos)
  attach(in_data)
  
  ### Create variables of interest by summing across unused cross-tabs
  for (a in c("A18to24", "A25to34", "A35to44", "A45to64", "AGe65")){
    for (g in c("Gf", "Gm")){
      # Add across age and gender to get individuals without high school diploma  
      assign(paste0("EdAtt", g, a, "_LtHs"),
             get(paste0("EdAtt", g, a, "_Lt9")) +
             get(paste0("EdAtt", g, a, "_HsDo")))
    }
    # Add across age and gender to get weight
    assign(paste0("EdAtt", g, a),
           get(paste0("EdAtt", g, a)) +
             get(paste0("EdAtt", g, a)))
  }
  
  ### Construct desired measures
  out_data <- within(out_data, {
    for (a in c("A18to24", "A25to34", "A35to44", "A45to64", "AGe65")){
      for (g in c("Gf", "Gm")) {
        assign(paste0("nEdAtt", g, a, "_LtHs"),
               get(paste0("EdAtt", g, a, "_LtHs")))
        assign(paste0("wEdAtt", g, a, "_LtHs"),
               get(paste0("EdAtt", g, a)))
        assign(paste0("rEdAtt", g, a, "_LtHs"),
               get(paste0("nEdAtt", g, a, "_LtHs")) / 
                 get(paste0("wEdAtt", g, a, "_LtHs"))) 
      }
    }
    rm(a)
    rm(g) # XXX: does this need to go here or nested in the previous loop?
  })
  
  ### Clean up and output
  detach(in_data)
  return(out_data)
}