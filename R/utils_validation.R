#' Validate a DatabaseConnector connection
#'
#' @keywords internal
validateConnection <- function(connection) {
  if (is.null(connection)) {
    stop("connection must not be NULL.", call. = FALSE)
  }
  # DatabaseConnector connections typically have a 'dbms' attribute
  if (is.null(attr(connection, "dbms"))) {
    stop("Connection missing 'dbms' attribute.", call. = FALSE)
  }
}

#' Validate supported dialect via CommonDataModel
#'
#' @keywords internal
validateDialect <- function(targetDialect) {
  supported <- CommonDataModel::listSupportedDialects()
  if (!(tolower(targetDialect) %in% tolower(supported))) {
    stop(sprintf("Dialect '%s' is not supported. Supported dialects: %s",
                 targetDialect, paste(supported, collapse = ", ")), call. = FALSE)
  }
}

#' Validate structure of extracted data
#'
#' @keywords internal
validateExtractedData <- function(data) {
  req <- c("condition_concept_id", "concept_name", "year", "month", "patient_count")
  missing <- setdiff(req, names(data))
  if (length(missing) > 0) {
    stop(sprintf("Extracted data is missing required columns: %s",
                 paste(missing, collapse = ", ")), call. = FALSE)
  }
  if (!is.numeric(data$patient_count)) {
    stop("patient_count must be numeric.", call. = FALSE)
  }
}