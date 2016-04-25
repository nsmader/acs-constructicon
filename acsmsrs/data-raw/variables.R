raw_files <- list(
    list(end_year = 2009,
         filename = "variables_2009.json",
         url = "http://api.census.gov/data/2009/acs5/variables.json"),
    list(end_year = 2010,
         filename = "variables_2010.json",
         url = "http://api.census.gov/data/2010/acs5/variables.json"),
    list(end_year = 2011,
         filename = "variables_2011.json",
         url = "http://api.census.gov/data/2011/acs5/variables.json"),
    list(end_year = 2012,
         filename = "variables_2012.json",
         url = "http://api.census.gov/data/2012/acs5/variables.json"),
    list(end_year = 2013,
         filename = "variables_2013.json",
         url = "http://api.census.gov/data/2013/acs5/variables.json"),
    list(end_year = 2014,
         filename = "variables_2014.json",
         url = "http://api.census.gov/data/2014/acs5/variables.json"))

for (raw_file in raw_files) {
    path <- paste0("data-raw/", raw_file$filename)
    if (!file.exists(path)) {
        message("Pulling variable info. for ", raw_file$end_year,
                " 5-year survey")
        download.file(raw_file$url, path, quiet = TRUE)
    } else {
        message("Using existing variable info. for ", raw_file$end_year,
                " 5-year survey")
    }
}
