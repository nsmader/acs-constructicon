# Path to where key file is stored by acs package.
acs_key_path <- function(file = "key.Rda") {
    system.file(paste0("extdata/", file), package="acs")
}

# Read ASC API key from file
read_api_key <- function(file) {
    readChar(file, file.info(file)$size - 1)
}

#' Retrieve installed ACS API key
#'
#' @param file The filename for the installed ACS API key
retrieve_api_key <- function(file = "key.Rda") {
    if (have_api_key(file)) {
        load(acs_key_path(file))
        key
    } else {
        NA
    }
}

#' Test if ACS API is installed.
#'
#' @param file The filename for the installed ACS API key
#'
#' @seealso \code{\link{load_api_key}} for loading from file,
#'   and \code{\link{enter_api_key}} for entering with interactive prompt.
have_api_key <- function(file = "key.Rda") {
    file_test("-f", acs_key_path(file))
}

#' Prompt user to update ASC API key.
#'
#' @param file The filename for the installed ACS API key
#'
#' @seealso \code{\link{load_api_key}} for loading from file.
enter_api_key <- function(file = "key.Rda") {
    api_key <- readline(prompt = "Enter API key: ")
    acs::api.key.install(api_key, file = file)
}

#' Load ASC API key from file.
#'
#' @param source_file A file containing an ACS API key
#' @param file The filename for the installed ACS API key
#'
#' @seealso \code{\link{enter_api_key}} for entering with interactive prompt.
load_api_key <- function(source_file,
                         file = "key.Rda") {
    if (file_test("-f", source_file)) {
        api_key <- read_api_key(source_file)
        acs::api.key.install(api_key, file = file)
    } else {
        stop("Invalid key filename.")
    }
}
