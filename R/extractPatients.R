#' Extract counts of distinct patients with conditions by year and month
#'
#' @description
#' Queries OMOP CDM condition_occurrence (joined to concept) to compute distinct
#' patient counts per condition, aggregated by year and month.
#'
#' @param connection DatabaseConnector connection object. Must include a 'dbms' attribute.
#' @param cdmSchema Character. Schema that contains OMOP CDM tables (e.g., "main" for SQLite, or "cdm" / "database.cdm").
#'
#' @return A data.frame with columns:
#'   - condition_concept_id (integer)
#'   - concept_name (character)
#'   - year (integer)
#'   - month (integer)
#'   - patient_count (integer)
#'
#' @examples
#' \dontrun{
#' connection_details <- Eunomia::getEunomiaConnectionDetails()
#' conn <- connect(connection_details)
#' df <- extractPatients(connection = conn, cdmSchema = "main")
#' DatabaseConnector::disconnect(conn)
#' }
#'
#' @export
extractPatients <- function(connection, cdmSchema = "main") {
  # Input validation
  validateConnection(connection)
  if (!is.character(cdmSchema) || length(cdmSchema) != 1) {
    stop("cdmSchema must be a single character value.", call. = FALSE)
  }

  # Load SQL template from package
  sqlPath <- system.file("sql", "get_condition_counts.sql", package = "omoptrend")
  if (sqlPath == "") {
    stop("SQL file 'get_condition_counts.sql' not found in inst/sql.", call. = FALSE)
  }
  sqlTemplate <- paste(readLines(sqlPath, warn = FALSE), collapse = "\n")

  # Render schema placeholder
  rendered <- SqlRender::render(sql = sqlTemplate, cdmSchema = cdmSchema)

  # Validate and translate to target dialect
  targetDialect <- attr(connection, "dbms")
  validateDialect(targetDialect)
  translated <- SqlRender::translate(sql = rendered, targetDialect = targetDialect)

  # Execute query
  df <- tryCatch({
    DatabaseConnector::querySql(connection, translated)
  }, error = function(e) {
    stop(sprintf("Failed to execute extractPatients SQL: %s", e$message), call. = FALSE)
  })

  df <- as.data.frame(df)

  # Coerce types (drivers may return character)
  df$year <- as.integer(df$year)
  df$month <- as.integer(df$month)
  df$patient_count <- as.integer(df$patient_count)
  df$condition_concept_id <- as.integer(df$condition_concept_id)

  # Structure validation
  validateExtractedData(df)

  return(df)
}