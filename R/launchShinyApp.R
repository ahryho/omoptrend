#' Launch the omoptrend Shiny App with pre-extracted data
#'
#' @description
#' This function demonstrates the full workflow of the `omoptrend` package using the  OMOP CDM dataset.
#'
#' @details 
#' The Shiny App contains:
#'  - Condition selector (pulldown menu): Lets the user choose a condition from the dataset.
#'  - Time granularity toggle (checkbox): Switches between yearly (byMonth = FALSE) and monthly (byMonth = TRUE) views.
#'  - Calendar input (dateRangeInput): Allows the user to filter the dataset by a specific date range, so they can zoom in on a subset of years or months.
#'  - Dynamic plot: Uses plotTrend() internally to render the frequency of the selected condition over the chosen time frame. 
#'  The plot refreshes automatically when the user changes the condition, time granularity, or calendar range.
#'
#' @param data data.frame produced by extractPatients()
#'
#' @return
#' This function does not return a value. It launches a Shiny application.
#'
#' @examples
#' \dontrun{
#' connectionDetails <- Eunomia::getEunomiaConnectionDetails()
#' conn <- DatabaseConnector::connect(connectionDetails)
#' df <- extractPatients(connection = conn, cdmSchema = "main")
#' launchShinyApp(data = df)
#' }
#'
#' @export
launchShinyApp <- function(data) {
  if (missing(data)) {
    stop("You must provide a data frame from extractPatients().", call. = FALSE)
  }
  validateExtractedData(data)

  appFile <- system.file("shiny", "app", "app.R", package = "omoptrend")
  if (appFile == "")
    stop("Shiny app file not found.", call. = FALSE)

  # Source the app definitions
  source(appFile, local = TRUE)

  # Run the app with the provided data
  shiny::shinyApp(ui = ui, server = server(data))
}