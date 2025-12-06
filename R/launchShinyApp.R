#' Launch the omoptrend Shiny app with pre-extracted data
#'
#' @param data data.frame produced by extractPatients()
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