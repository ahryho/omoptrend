#' Run a demo Shiny App
#' 
#' This helper function demonstrates the full workflow of the `omoptrend` package
#' using the  OMOP CDM dataset provided by the **Eunomia** package.
#' It establishes a Eunomia connection, extracts patient counts
#' for conditions over time, and launches the interactive Shiny app for exploration.
#'
#'
#' @details
#' Steps performed by this function:
#' \enumerate{
#'   \item Establishes a connection to the Eunomia SQLite database.
#'   \item Extracts patient-level condition counts from the OMOP CDM.
#'   \item Launches the Shiny app with the extracted data frame.
#' }
#'
#' @return
#' This function does not return a value. It launches a Shiny application
#' in the user's default web browser.
#'
#' @examples
#' \dontrun{
#' # Run the demo Shiny App
#' launchShinyAppDemo()
#' }
#'
#' @export
launchShinyAppDemo <- function() {
  connectionDetails <- Eunomia::getEunomiaConnectionDetails()
  conn <- DatabaseConnector::connect(connectionDetails)
  df <- extractPatients(connection = conn, cdmSchema = "main")
  DatabaseConnector::disconnect(conn)
  launchShinyApp(df)
}