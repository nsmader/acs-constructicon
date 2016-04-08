#------------------------------------------------------------------------------------
# Pull all ACS meta-data into machine-readable format to be converted and typologized
#------------------------------------------------------------------------------------

library("acs")
library("xlsx")
try(setwd("~/GitHub/acs-constructicon/"))
try(setwd(dir = "/Users/imorey/Documents/GitHub/acs-constructicon/"), silent = TRUE)

# Identify all tables
tableMeta <- read.xlsx("./doc/ACS_2013_SF_5YR_Appendices.xls", 1)

# Generate function to parse variable names
parseVarname <- function(varnames){
  #mySplit <- strsplit(varnames, split = "(?<![0-9]):", perl = TRUE)
    # Split on colon, so long as it doesn't correspond to a time of day
    #  (which we check by ruling out any colons which occur after a number)
    
    # IMM: I believe there can be colons after numbers that are not
    # representing the time of day. 
    # Update: After running this script on my local drive I can confirm that I'm 
    # seeing instances where components should have been parsed out, but were not.
    # Example: "With related children under 18: With own children under 18:"
  
  # This appears to work!
  mySplit <- strsplit(varnames, split = ":(?![0-9])", perl = TRUE)
  
  #myUnlist <- sapply(unlist(mySplit), function(x) gsub("^ | $", "", x))
  myUnlist <- sapply(unlist(mySplit), function(x) gsub("^\\s+|\\s+$", "", x))
  return(unique(myUnlist))
}

# Parse variable names
myTables <- as.character(tableMeta$Table.Number)
myTables <- myTables[!grepl("PR$|B05011|B09018|B09019|B09020|B10052", myTables) & !is.na(myTables)]
  # The specific tables mentioned here just happened to create problems (that haven't yet been investigated)

# myTables <- gsub(" ", "", unlist(strsplit(c("B08011, B08132, B08133, B08302, B08532, B08602"), split = ",")))

parsedOut <- NULL
for (myT in 1:length(myTables)){
  myTable <- myTables[myT]
  if (myT %% 25 == 0) print(paste(myT / length(myTables), "done"))
  meta <- try(acs.lookup(endyear = 2013,
                         span = 5,
                         dataset = "acs",
                         table.number = myTable),
              silent = T)
  if (class(meta)=="try-error") next() # This is necessary because some table numbers in the documentation are not available from the API
  parsedNames <- parseVarname(meta@results$variable.name)
  parsedOut <- unique(c(parsedOut, parsedNames))
}
write.csv(parsedOut, "./data/parsed-components-of-variable-names_imm.csv", row.names = FALSE)

