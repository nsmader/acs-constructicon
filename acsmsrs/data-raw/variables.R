# Methods for retrieving, processing, and loading ACS variables data.
# The update_variables_info() method is the main entry point.

library(jsonlite)
library(stringr)
library(tidyr)
library(dplyr)

look_up_code <- function(x, codes) {
    code <- codes[codes$x == x,]$varStub
    if (length(code) == 0 || code == "") {
        code <- NA
    }

    code
}

parse_label <- function(label, codes) {
    tokens <- str_split(label, ":!!|!!")[[1]]
    sapply(tokens, look_up_code, codes, USE.NAMES = FALSE)
}

var_path <- function(end_year, span, ext) {
    paste0("data-raw/variables_", end_year, "_", span, ext)
}

json_path <- function(end_year, span) {
    var_path(end_year, span, ".json")
}

json_url <- function(end_year, span) {
    paste0("http://api.census.gov/data/", end_year,
           "/acs", span, "/variables.json")
}

data_path <- function(end_year, span) {
    var_path(end_year, span, ".Rda")
}

data_var <- function(end_year, span) {
    paste("codes", end_year, span, sep = "_")
}

# Downloads variables metadata in JSON format for the specified survey.
download_variables_json <- function(end_year, span, use_cache = TRUE) {
    if (use_cache && file.exists(json_path(end_year, span))) {
        message("Using existing variable info. for ", end_year, " ACS ",
                span, "-year survey")
    } else {
        message("Pulling variable info. for ", end_year, " ACS ", span,
                "-year survey")
        download.file(url = json_url(end_year, span),
                      destfile = json_path(end_year, span),
                      quiet = TRUE)
    }
}

# Load variables data.
load_variables_data <- function(end_year, span, use_cache = TRUE) {
    if (use_cache && file.exists(data_path(end_year, span))) {
        message("Using existing variable data for ", end_year, " ACS ",
                span, "-year survey")
        load(data_path(end_year, span))
    } else {
        message("Generating variable data for ", end_year, " ACS ", span,
                "-year survey")
        assign(data_var(end_year, span),
               process_variables_json(end_year, span))
        save(list = data_var(end_year, span), file = data_path(end_year, span))
    }

    get(data_var(end_year, span))
}

# Encodes variable labels. Returns only variables that could be fully encoded.
encode_unique_labels <- function(variables) {
    stopifnot(file.exists("data-raw/codes.csv"))

    codes <- read.csv("data-raw/codes.csv", stringsAsFactors = FALSE)
    labels <- unique(variables$label)
    codings <- lapply(labels, parse_label, codes)

    # Filter for fully coded vars
    full_codings <- sapply(codings, function(x) !any(is.na(x)))
    full_labels <- labels[full_codings]
    full_codes <- sapply(codings[full_codings], paste, collapse = "_")

    data.frame(label = full_labels, code = full_codes)
}

# Processes raw JSON metadata. Returns a collection of data frames, one
# per table.
process_variables_json <- function(end_year, span) {
    stopifnot(file.exists(json_path(end_year, span)))

    json <- fromJSON(json_path(end_year, span))

    # Filter for only estimate variables (non-PR)
    est_vars <- str_match(names(json$variables), "^B[0-9]+_[0-9]+E$")
    variables <- json$variables[!is.na(est_vars)]

    # Convert hierarchical data to tabular representation
    variables <- data.frame(variable = names(variables),
                            label = sapply(variables, `[[`, "label"),
                            stringsAsFactors = FALSE,
                            row.names = NULL)

    # Clean data set
    variables <- variables %>%
        mutate(variable = str_sub(variable, end = str_length(variable) - 1)) %>%
        mutate(id = variable) %>%
        separate(variable, c("table", "variable"), sep = "_")

    # Encode unique labels
    encodings <- encode_unique_labels(variables)
    coded_data <- merge(variables, encodings)

    # Split based on table name
    tables <- unique(coded_data$table)
    sub_table <- function(x, df) df[df$table == x, ]
    data <- lapply(tables, sub_table, df = coded_data)
    names(data) <- tables

    data
}

# Retrieves and processes variables info for the specified survey.
update_variables_info <- function(end_year, span, use_cache = TRUE) {
    download_variables_json(end_year, span, use_cache)
    load_variables_data(end_year, span, use_cache)
}
