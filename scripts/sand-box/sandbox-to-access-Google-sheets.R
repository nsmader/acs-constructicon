#sandbox for reading data from google spreadsheets

library("mosaic")
mydat = fetchData("https://docs.google.com/spreadsheets/d/1Dc0UVIW-yoKBSP7mHsayX5JNQiSkfr9v5UtilcGSXDY/export?gid=0&format=csv")
str(mydat)

# Also see the RGoogleDocs (http://www.omegahat.org/RGoogleDocs/) and RGoogleData (http://r-forge.r-project.org/projects/rgoogledata/)
# packages