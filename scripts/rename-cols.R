#-------------------------------------------------------------------------------
# Function to rename column variables
#-------------------------------------------------------------------------------
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
    # This prior command replaces only colons that aren't preceded by a number (to not replace those as parts of times of day)
  colnames(renamed) <- gsub(":$", "", colnames(renamed))
    # For some reason, trailing colons still needed to be removed
  
  # Substitute names
  # /!\ maybe sapply this instead?
  hold <- renamed
  renamed <- hold
  for (i in 1:nrow(sub.patterns)){
    if (any(grepl(descriptors[i], colnames(renamed)))) {
      #print(colnames(renamed))
      print(descriptors[i])
      #browser()
    }
    colnames(renamed) <- gsub(pattern = descriptors[i],
                              replacement = newnames[i],
                              x = colnames(renamed))
  }
  
  return(renamed)
}
