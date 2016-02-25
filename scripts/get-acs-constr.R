#-------------------------------------------------------------------------------
# Load relevant libraries and files
#-------------------------------------------------------------------------------
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
# endyear = 2013; span = 5; constr <- "Child Poverty"; nametype <- "var"
# endyear = 2013; span = 5; constr <- "Teen Birth Rate"; nametype <- "var"

getAcsConstr <- function(geo, endyear, span, constr, nametype = "var"){
  
  ### Look up tables involved with the requested construction(s)
    constr.tables <- unlist(strsplit(constr.ref$acs_tables_req[constr.ref$constructions == constr], split = ","))
  
  ### Use the acs package to pull those ACS tables using the other supplied parameters
    for (ixt in 1:length(constr.tables)){
      myt <- constr.tables[ixt]
      
      # Pull data for the table
      try(acs.pull <- acs.fetch(geography = geo,
                                endyear = endyear,
                                span = span,
                                table.number = myt), silent = TRUE)
      acs.est <- acs.pull@estimate
      acs.est.df <- data.frame(acs.est)
      
      # Need to give the columns the descriptions
      meta <- acs.lookup(endyear = endyear, span = span, dataset = "acs", table.number = myt)
      colnames(acs.est.df) <- meta@results$variable.name
      
      # Need new row names for output. Do this with acs.pull@geography subelements
      rownames(acs.est.df) <- NULL
      acs.est.df$geoid <- paste0(sprintf("%02d", acs.pull@geography$state),
                                 sprintf("%03d", acs.pull@geography$county),
                                 acs.pull@geography$tract) # For whatever reason, tract is already character format, with leading zeroes
      acs.est.df$tract <- acs.pull@geography$tract
      
      if (ixt == 1){
        raw.tables <- acs.est.df
      } else {
        raw.tables <- merge(x = raw.tables,
                            y = acs.est.df,
                            by = geoid)
      }
    }
  
  ### Rename the column elements in those tables
    renamed.tables <- nameTables(tables = rawTables,
                                 nametype = nametype)
  
  ### Call a script which constructs desired measures from the table elements
    myscript <- constr.ref$script_file[constr.ref$constructions == constr]
    source(paste0("scripts/constr-scripts/", myscript))
    constr.vars <- ep(paste0(gsub("-|.R", "", myscript), "(renamed.tables)"))
    
  return(constr.vars)
    
}

