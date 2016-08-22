# This script creates child poverty measures using table B17006
# See https://www.socialexplorer.com/data/ACS2013_5yr/metadata/?ds=American+Community+Survey+Tables%3A++2009+--+2013+%285-Year+Estimates%29&table=B17006
sexbyage <- function(in_data, geos){
  
  ### Set up data to work with
  out_data <- subset(in_data,
                     select = colnames(in_data) %in% geos)
  attach(in_data)
  
  ages <- c("Lt5", "5to9", "10to14", "15to17", "18to19", "20", "21",
            "22to24", "25to29", "30to34", "35to39", "40to44", "45to49",
            "50to54", "55to59", "60to61", "62to64", "65to66", "67to69",
            "70to74", "75to79", "80to84", "Ge85")
  
  ### Create variables of interest by summing across unused cross-tabs
  for (a in ages){
    # Add across genders to get all individuals of given age
    assign(paste0("A", a),
           get(paste0("GM_A", a)) +
           get(paste0("GF_A", a)))
  }
  
  ### Construct desired measures
  out_data <- within(out_data, {
    nAll <- all
    for (a in ages){
      # Create rates of age, unconditional on gender
      assign(paste0("nA", a),
             get(paste0("A", a)))
      assign(paste0("wA", a),
             get("all"))
      assign(paste0("rA", a),
             get(paste0("nA", a)) / 
             get(paste0("wA", a)))
      
      for (g in c("M", "F")){
        # Create rates of age, conditional on gender
        assign(paste0("nG", g, "_A", a),
               get(paste0("G", g, "_A", a)))
        assign(paste0("wG", g, "_A", a),
               get(paste0("G", g)))
        assign(paste0("rG", g, "_A", a),
               get(paste0("nG", g, "_A", a)) / 
               get(paste0("wG", g, "_A", a)))
        
        # Create rates of gender
        assign(paste0("nAll_G", g),
               get(paste0("G", g)))
        assign(paste0("wAll_G", g),
               get("all"))
        assign(paste0("rAll_G", g),
               get(paste0("nAll_G", g)) / 
               get(paste0("wAll_G", g)))
      }
    }
    rm(a, g)
  })
  
  ### Clean up and output
  detach(in_data)
  return(out_data)
}