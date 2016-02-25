# This script creates child poverty measures using table B17006
# See https://www.socialexplorer.com/data/ACS2013_5yr/metadata/?ds=American+Community+Survey+Tables%3A++2009+--+2013+%285-Year+Estimates%29&table=B17006
childpov <- function(in_data, geos){
  
  ### Set up data to work with
  out_data <- subset(in_data,
                     select = colnames(in_data) %in% geos)
  attach(in_data)
  
  ### /!\ Consider creating additional age categories, like Age 5 and younger
  # by adding the lt5 and 5 counts
  
  ### Create variables of interest by summing across unused cross-tabs
  for (a in c("Alt5", "A5", "A6to17")){
    for (eq in c("Lt", "Ge")){
      # Add across family types to get all youth in given poverty situation
      assign(paste0("IncPrev12mo", eq, "Pov_", a),
             get(paste0("IncPrev12mo", eq, "Pov_FamMar_", a)) +
             get(paste0("IncPrev12mo", eq, "Pov_FamOth_HhGmNWife_", a)) +
             get(paste0("IncPrev12mo", eq, "Pov_FamOth_HhGfNHus_", a)))
    }
    # Add across poverty types to get all youth with measured poverty status
    assign(paste0("IncPrev12mo_", a),
           get(paste0("IncPrev12moLtPov_", a)) +
           get(paste0("IncPrev12moGePov_", a)))
  }
  
  ### Construct desired measures
  out_data <- within(out_data, {
    for (a in c("Alt5", "A5", "A6to17")){
      assign(paste0("nPov_", a),
             get(paste0("IncPrev12moLtPov_", a)))
      assign(paste0("wPov_", a),
             get(paste0("IncPrev12mo_", a)))
      assign(paste0("rPov_", a),
             get(paste0("nPov_", a)) / 
             get(paste0("wPov_", a)))
    }
    rm(a)
  })
  
  ### Clean up and output
  detach(in_data)
  return(out_data)
}