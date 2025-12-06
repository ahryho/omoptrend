#' Launch the omoptrend Shiny App
#'
#' @description
#' This is a helper function that automates the workflow of the package.
#'
#' @details
#' Steps performed by this function:
#' \enumerate{
#'   \item Establishes a Eunomia connection.
#'   \item Extracts patient-level condition counts from the OMOP CDM.
#'   \item Launches the Shiny app with the extracted data frame.
#' }
#'
#' The Shiny App contains:
#'  - Condition selector (pulldown menu): Lets the user choose a condition from the dataset.
#'  - Time granularity toggle (checkbox): Switches between yearly (byMonth = FALSE) and monthly (byMonth = TRUE) views.
#'  - Calendar input (dateRangeInput): Allows the user to filter the dataset by a specific date range, so they can zoom in on a subset of years or months.
#'  - Dynamic plot: Uses plotTrend() internally to render the frequency of the selected condition over the chosen time frame. 
#'  The plot refreshes automatically when the user changes the condition, time granularity, or calendar range.
#'
#' @return
#' This function does not return a value. It launches a Shiny application in the user's default web browser.
#'
#' @examples
#' \dontrun{
#' # Run the Shiny App
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