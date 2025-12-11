library(shiny)
library(ggplot2)
library(omoptrend)

# UI -------------------------------
ui <- fluidPage(
  # Title of the app
  titlePanel("OMOP CDM Condition Trends"),

  # Layout with sidebar for controls and main panel for plot
  sidebarLayout(
    sidebarPanel(
      # Dropdown to select a condition (choices populated dynamically in server)
      selectInput("condition", "Condition", choices = NULL, selected = NULL),

      # Checkbox to toggle between yearly vs month-only aggregated view
      checkboxInput("byMonth", "Plot aggregated by month (Jan-Dec)", value = FALSE),

      # Calendar-style date range input to filter the dataset
      dateRangeInput("dateRange", "Filter by calendar date range",
                     start = NULL, end = NULL, format = "yyyy-mm-dd"),

      # Helper text for user guidance
      helpText("Select condition and a calendar date range. Plot updates accordingly.")
    ),
    mainPanel(
      # Output for the trend plot
      plotOutput("trendPlot")
    )
  )
)

# SERVER -------------------------------

# server() takes a data.frame (appData) produced by extractPatients()
# and returns a Shiny server function that uses that data.
server <- function(appData) {
  function(input, output, session) {
    # Validate that appData has required columns
    omoptrend:::validateExtractedData(appData)

    # Build a date column for filtering (first day of each month)
    # This allows dateRangeInput to filter by calendar dates
    appData$filterDate <- as.Date(sprintf("%d-%02d-01",
                                          as.integer(appData$year),
                                          as.integer(appData$month)))

    # Populate condition choices dynamically
    observe({
      choices <- sort(unique(appData$concept_name))
      updateSelectInput(session, "condition", choices = choices, selected = choices[1])
    })

    # Initialize date range to min/max available in the data
    observeEvent(appData, {
      dr <- range(appData$filterDate, na.rm = TRUE)
      updateDateRangeInput(session, "dateRange", start = dr[1], end = dr[2])
    }, once = TRUE)

    # Filter data based on user input
    filtered <- reactive({
      req(input$condition)  # Ensure a condition is selected
      df <- subset(appData, concept_name == input$condition)

      # Apply calendar date range filter if provided
      if (!is.null(input$dateRange) && all(!is.na(input$dateRange))) {
        df <- df[df$filterDate >= input$dateRange[1] & df$filterDate <= input$dateRange[2], ]
      }
      df
    })

    # Render the plot
    output$trendPlot <- renderPlot({
      df <- filtered()
      req(nrow(df) > 0)  # Ensure there is data to plot
      omoptrend::plotTrend(data = df, byMonth = isTRUE(input$byMonth))
    })
  }
}