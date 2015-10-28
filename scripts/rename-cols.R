#------------------------------------------------------------------------------#
# Function to rename column variables
#------------------------------------------------------------------------------#

### Import information used to code descriptors into shorter names -------------

try(setwd(dir = "~/GitHub/acs-constructicon/"), silent = TRUE)
sub.patterns <- read.csv(file = "data/parsed-components-of-variable-names_coded.csv",
                         stringsAsFactors = FALSE)
sub.patterns <- sub.patterns[order(nchar(sub.patterns$x), decreasing = TRUE),]
  # This step is used to order the longest strings first, so that substrings 
  # do not get replaced before longer strings containing them do

### Establish function to perform the renaming ---------------------------------

nameTables <- function(tables, nametype){
  # Run successive gsub()s to get variable names out of 
  renamed <- raw.tables
  descriptors <- sub.patterns$x
  newnames <- sub.patterns[[switch(nametype,
                                   "var" = "varStub",
                                   "semantic" = "semanticStub")]]

  # Remove lead and trailing spaces, and replace colons
  colnames(renamed) <- gsub("^ | $", "", colnames(renamed))
  colnames(renamed) <- gsub("(?<![0-9]):[ ]", "_", colnames(renamed), perl = TRUE)
    # This prior command replaces only colons that aren't preceded by a number
    # (to not replace those as parts of times of day)
  colnames(renamed) <- gsub(":$", "", colnames(renamed))
    # For some reason, trailing colons still needed to be removed
  
  # Substitute names
  # /!\ maybe sapply this instead?
  hold <- renamed
  renamed <- hold
  for (i in 1:nrow(sub.patterns)){

    # Since we're using regular expressions for replacements, make sure that
    # parentheses in the descriptors are indicated as literals, using back-slashes
    mydescr <- gsub("\\(", "\\\\(", descriptors[i])
    mydescr <- gsub("\\)", "\\\\)", mydescr)
      # These replace e.g. "(" in the descriptors value with "\\("
    
    colnames(renamed) <- gsub(pattern = mydescr,
                              replacement = newnames[i],
                              x = colnames(renamed))
  }
  
  return(renamed)
}
