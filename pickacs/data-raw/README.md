# Summary of data-raw files

This folder contains files and scripts that manage the meta-data necessary for the operation of the package. An overview of the contents:

* `variables.R` -- 
* `update_sysdata.R` -- this uses the `update_variables_info()` function to pull variable meta-data directly from the Census API. The results are all offered for use to the built package using the `devtools::use_data()` function.
* `codes.csv` -- this a cross-walk table, used to translate token elements of Census field descriptions to translated table names. For example, "5 to 9 years" is translated to "A5to9".


For example, B17006 is a table related to (its meta-data can be viewed on the Social Explorer web page [here](https://www.socialexplorer.com/data/ACS2014_5yr/metadata/?ds=ACS14_5yr&table=B17006))

## `variables.R`

The `look_up_code()` function returns a variable stub equivalent to a given code. For example ... /!\.

The `parse_label()` takes a longer field label, for example ... /!\, and splits it into a vector of , based on the ":!! and "!!" delimiters used by the Census API to separate label elements. It then goes through each token and translates it into a looked-up variable stub using `look_up_code()`.

The `var_path()` function returns a string representing a file path and name, formed by concatenating the end year, span, and extension that are provided.

The `json_path()` function returns a string representing a file path and name, for a json file for the end year span that are provided.

The `json_url()` function returns a string representing the ACS json endpoint, formed by the end year and span that are provided.

The `data_path()` function returns a string representing a file path and name, for an Rda file for the end year span that are provided.

The `data_var()` This function returns a "_"-delimited string, with a name of a data set, concatenating "codes" with the end year and span that are provided.

The `download_variables_json()` function manages the download of ACS data, checking first for the presence of already-downloaded data (unless the user specifically requests a fresh download).

The `load_variables_data()` function loads data into memory. If the requested data is already downloaded in `.Rda` form (and the user does not specifically request a fresh download), then the function loads the existing data. Otherwise, the json data is processed using `process_variables_json()`, and saved in .Rda form. Then, the `.Rda` variables for the requested end year and span is returned by the function.

The `encode_unique_labels()` function is called with a set of field labels. It loads the `codes.csv` file, parses each of the labels--both splitting and recoding them--subsets to only the labels whose tokens were all found for recoding, and then recombines the recoded label tokens.

The `process_variables_json()` function reads the json file corresponding to a given end year and span, filters to fields beginning with "B", ending with "E"--representing "E"stimates rather than "M"argins of error, and avoids Puerto Rico estimates--and preserves rows that are not NAs  (which is the case when a variable does not match the filter). The names of the tables and and then labels are arranged in a table. These names are then trimmed of their last character (specifically the "E"), and split into table and variable name components. (/!\ Example.) These field names or "variables" are then coded (if possible). This then returns a list object with each element representing a table from the full pull.

/!\ Note that tables beginning with "C" may also be of interest.

The `update_variables_info()` function calls both the download_variables_json() and load_variables_data() functions.


## `update_sysdata.R`

This script sources the code in the `variables.R` file, pulls a specified list of ACS meta data sets representing a range of end year/spans, and prepares the data for use by the rest of the scripts in the package.

## `codes.csv`

This document represents a mapping between label tokens and variable stubs.