#------------------------------------------------------------------------------------
# Pull all ACS meta-data into machine-readible format to be converted and typologized
#------------------------------------------------------------------------------------

library("acs")
library("xlsx")
setwd("~/GitHub/acs-constructicon/")

# Identify all tables
tableMeta <- read.xlsx("./doc/ACS_2013_SF_5YR_Appendices.xls", 1)

# Generate function to parse variable names
parseVarname <- function(varnames){
  mySplit <- strsplit(varnames, split = ":")
  myUnlist <- sapply(unlist(mySplit), function(x) gsub("^ | $", "", x))
  return(unique(myUnlist))
}

# Parse variable names
myTables <- as.character(tableMeta$Table.Number)
myTables <- myTables[!grepl("PR$|B05011|B09018|B09019|B09020|B10052", myTables) & !is.na(myTables)]
parsedOut <- NULL
for (myT in 1:length(myTables)){
  myTable <- myTables[myT]
  if (myT %% 25 == 0) print(paste(myT / length(myTables), "done"))
  meta <- try(acs.lookup(endyear = 2013, span = 5, dataset = "acs", table.number = myTable), silent = T)
  if (class(meta)=="try-error") next() # This is necessary because 
  parsedNames <- parseVarname(meta@results$variable.name)
  parsedOut <- unique(c(parsedOut, parsedNames))
}
write.csv(parsedOut, "./data/parsed-components-of-variable-names.csv", row.names = FALSE)

