#------------------------------------------------------------------------------------
# Pull all ACS meta-data into machine-readable format to be converted and typologized
#------------------------------------------------------------------------------------

library("acs")
library("xlsx")
setwd("~/GitHub/acs-constructicon/")

# Identify all tables
tableMeta <- read.xlsx("./doc/ACS_2013_SF_5YR_Appendices.xls", 1)

# Generate function to parse variable names
parseVarname <- function(varnames){
  mySplit <- strsplit(varnames, split = "(?<![0-9]):", perl = TRUE)
    # Split on colon, so long as it doesn't correspond to a time of day
    #  (which we check by ruling out any colons which occur after a number)
    # IMM: I believe there can be colons after numbers that are not
    # representing the time of day. For instance, B05010 is first broken out
    # by ratio of income to poverty (Under 1.00, 1.00 to 1.99, 2.0 and over) and
    # then there are further categories. In these cases, the string wouldn't be split
    # even though it is a valid cut point.
  myUnlist <- sapply(unlist(mySplit), function(x) gsub("^ | $", "", x))
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
write.csv(parsedOut, "./data/parsed-components-of-variable-names.csv", row.names = FALSE)

