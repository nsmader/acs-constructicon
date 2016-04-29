library(jsonlite)
library(stringr)
library(tidyr)

look_up_code <- function(x, codes) {
    code <- codes[codes$x == x,]$varStub
    if (length(code) == 0 || code == "") {
        code <- NA
    }

    code
}

parse_variable <- function(label, codes) {
    tokens <- str_split(label, ":!!|!!")[[1]]
    sapply(tokens, look_up_code, codes, USE.NAMES = FALSE)
}


# Generate variables data set from raw JSON file.
#
# Converts JSON representation to data frame. Subsets usable data. Cleans
# variable names.
gen_variables <- function(json_path, variables_path) {
    variables <- fromJSON(json_path)$variables
    # Filter out unused records
    variables <- variables[!is.na(str_match(names(variables), "^B[0-9]+_[0-9]+E$"))]
    # Convert hierarchical data to tabular representation
    variables <- data.frame(variable = names(variables),
                            label = sapply(variables, `[[`, "label"),
                            stringsAsFactors = FALSE,
                            row.names = NULL)
    # Clean data set
    variables <- variables %>%
        # Remove trailing 'E' from variable name
        mutate(variable = str_sub(variable, end = str_length(variable) - 1)) %>%
        mutate(id = variable) %>%
        separate(variable, c("table", "variable"), sep = "_")

    variables
}

# Generate list of encoded variables.
#
# Creates a list mapping encoded variable strings to underlying variable
# names (e.g., "IncPrev12moGePov_FamOth_HhGmNWife_ALt5" to "B17006_023")
# for look up in estimates matrix.
gen_var_list <- function(variables) {
    # Encode
    codes <- read.csv("data-raw/codes.csv", stringsAsFactors = FALSE)
    all_vars <- lapply(variables$label, parse_variable, codes)

    # Filter for fully-coded vars
    coded_vars <- sapply(all_vars, function(x) !any(is.na(x)))
    variables <- variables[coded_vars,]
    variables$label <- sapply(all_vars[coded_vars], paste, collapse = "_")

    # Construct lookup list
    var_list <- variables$id
    names(var_list) <- variables$label

    # Write out some helpful messages
    num_vars <- length(all_vars)
    message("Processed ", num_vars, " variables for ",
            raw_file$end_year, " 5-year survey")
    num_coded_vars <- nrow(variables)
    message("Found ", num_vars - num_coded_vars,
            " partially coded variables for ", raw_file$end_year,
            " 5-year survey")
    message("Found ", num_coded_vars,
            " fully coded variables for ", raw_file$end_year,
            " 5-year survey")

    var_list
}

raw_files <- list(
    list(end_year = 2009,
         filename = "variables_2009",
         url = "http://api.census.gov/data/2009/acs5/variables.json"),
    list(end_year = 2010,
         filename = "variables_2010",
         url = "http://api.census.gov/data/2010/acs5/variables.json"),
    list(end_year = 2011,
         filename = "variables_2011",
         url = "http://api.census.gov/data/2011/acs5/variables.json"),
    list(end_year = 2012,
         filename = "variables_2012",
         url = "http://api.census.gov/data/2012/acs5/variables.json"),
    list(end_year = 2013,
         filename = "variables_2013",
         url = "http://api.census.gov/data/2013/acs5/variables.json"),
    list(end_year = 2014,
         filename = "variables_2014",
         url = "http://api.census.gov/data/2014/acs5/variables.json")
)

acsmsrs_codes <- list()

for (raw_file in raw_files) {
    # Retrieve ACS variable information if not already present
    json_path <- paste0("data-raw/", raw_file$filename, ".json")
    if (!file.exists(json_path)) {
        message("Pulling variable info. for ", raw_file$end_year,
                " 5-year survey")
        download.file(raw_file$url, json_path, quiet = TRUE)
    } else {
        message("Using existing variable info. for ", raw_file$end_year,
                " 5-year survey")
    }

    # Convert raw JSON to easier-to-use data frame
    variables_path <- paste0("data-raw/", raw_file$filename, ".Rda")
    if (!file.exists(variables_path)) {
        message("Generating new variable data frame for ", raw_file$end_year,
                " 5-year survey")
        variables <- gen_variables(json_path)
        save(variables, file = variables_path)
    } else {
        message("Using existing variable data frame for ", raw_file$end_year,
                " 5-year survey")
        load(variables_path)
    }

    # Encode labels; store in list to make look up easy
    var_list_name <- as.character(raw_file$end_year)
    message("Generating new variable list for ", raw_file$end_year,
            " 5-year survey")
    var_list <- gen_var_list(variables)
    acsmsrs_codes[[var_list_name]] <- var_list
}

# Store data for use in package
devtools::use_data(acsmsrs_codes,
                   internal = TRUE,
                   overwrite = TRUE)
