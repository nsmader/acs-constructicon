#-------------------------------------------------------------------------------
# Load relevant libraries and files
#-------------------------------------------------------------------------------
rm(list = ls())
try(setwd(dir = "~/GitHub/acs-constructicon/"), silent = TRUE)
try(setwd(dir = "/Users/imorey/Documents/GitHub/acs-constructicon/"), silent = TRUE)
library(acs)
ep <- function(x) eval(parse(text = x))
myFileName <- "./key/key.txt"
myKey <- readChar(myFileName, file.info(myFileName)$size)
api.key.install(myKey, file = "key.rda")
constr.ref <- read.csv(file = "data/constructions-lookup.csv",
                       stringsAsFactors = FALSE)
source("scripts/rename-cols.R")

#-------------------------------------------------------------------------------
# Base function used for top-level calls
#-------------------------------------------------------------------------------

# geo <- geo.make(state = "IL", county = "Cook", tract = "*")
# endyear = 2013; span = 5; constr = "Child Poverty"; nametype = "var"
# endyear = 2014; span = 5; constr = "Teen Birth Rate"; nametype = "var"
# endyear = 2013; span = 5; constr = "Ed by Age, Sex"; nametype = "var"
# endyear = 2014; span = 5; constr = "Sex by Age"; nametype = "var"

# Try specifying all counties in Illinois
ilCounties <- geo.lookup(state = "IL", county = "*")
myCounties <- ilCounties$county.name[!is.na(ilCounties$county.name)]
geo <- geo.make(state = "IL", county = myCounties, tract = "*", block.group = "*") # Works

# geo <- geo.make(state = "IL", county = c("Cook", "Lake"), tract = "*", block.group = "*")
# geo <- geo.make(state = "IL", county = "*", tract = "*", block.group = "*")
# endyear = 2014; span = 5; constr = "Sex by Age"; nametype = "var"

myConstr <- getAcsConstr(geo = geo, endyear = 2014, span = 5, constr = "Sex by Age")

getAcsConstr <- function(geo, endyear, span, constr, nametype = "var"){
  
  ### Look up tables involved with the requested construction(s)
    constr.tables <- unlist(strsplit(with(constr.ref, acs_tables_req[constructions == constr]),
                                     split = ","))
  
  ### Use the acs package to pull those ACS tables using the other supplied parameters
    for (ixt in 1:length(constr.tables)){
      myt <- constr.tables[ixt]
      
      # Pull data for the table
      try(acs.pull <- acs.fetch(geography = geo,
                                endyear = endyear,
                                span = span,
                                table.number = myt), silent = TRUE)
      acs.est.df <- data.frame(acs.pull@estimate)
      
      # Need to give the columns the descriptions
      meta <- acs.lookup(endyear = endyear, span = span, dataset = "acs", table.number = myt)
      colnames(acs.est.df) <- meta@results$variable.name
      
      # Need new row names for output. Do this with acs.pull@geography subelements
      rownames(acs.est.df) <- NULL
      acs.est.df <- within(acs.est.df, {
        state  <- sprintf("%02d", acs.pull@geography$state)
        county <- sprintf("%03d", acs.pull@geography$county)
        tract <- acs.pull@geography$tract # For whatever reason, tract is already character format, with leading zeroes
        blockgroup <- ifelse(length(acs.pull@geography$blockgroup)==0, "", acs.pull@geography$blockgroup)
        geoid <- paste0(state, county, tract, blockgroup)
      })
      
      if (ixt == 1){
        raw.tables <- acs.est.df
      } else {
        raw.tables <- merge(x = raw.tables,
                            y = acs.est.df,
                            by = geoid)
      }
    }
  
  ### Rename the column elements in those tables
    renamed.tables <- nameTables(tables = raw.tables,
                                 nametype = nametype)
  
  ### Call a script which constructs desired measures from the table elements
    selectableGeographies <- c("geoid", "us", "region", "division", "state", "county",
                             "subminor", "place", "tract", "blockgroup",
                             "consolidated+city", "alaska+native+regional+corporation",
                             "american+indian+area/alaska+native+area/hawaiian+home+land",
                             "tribal+subdivision")
    myscript <- with(constr.ref, script_file[constructions == constr])
    source(paste0("scripts/constr-scripts/", myscript)) # Source the script to get the function
    constr.vars <- ep(paste0(gsub("-|.R", "", myscript), "(renamed.tables, geos = selectableGeographies)")) # Run the function on our tables
    
  return(constr.vars)
    
}

