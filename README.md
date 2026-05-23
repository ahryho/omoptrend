# omoptrend

_A small exercise to play around with an [OMOP CDM](https://ohdsi.github.io/CommonDataModel/cdm54.html) dataset using [Eunomia](https://ohdsi.github.io/Eunomia/)._

An R package for exploring patient condition trends in OMOP CDM databases. It provides functions to extract patient counts, visualize trends, and launch an interactive Shiny app.

## The scope 

Create an R package that exports the following functions:

1. `extractPatients(connection)`

This function takes a database connection as input, and extract counts of all conditions by year and month from the condition occurence table in the OMOP CDM database. The function is able to do this for different sql dialects using the [SqlRender R package](https://ohdsi.github.io/SqlRender/). It returns a data.frame with the data needed for the `plotTrend` function.

2. `plotTrend(data, byMonth = FALSE)` 

`plotTrend` takes output from the `extractPatients` function as input and returns a plot with the number of patients per year (default) or per month for each condition in "data".

3. `launchShinyApp()`

Starts the shiny app with a pulldown menu to filter the data by condition and a checkbox (boolean input) for the `byMonth` parameter in `plotTrend`. The app then plots the frequency of the selected condition by the selected time frame (Year or Month).

## Installation

Clone the repository and install from source:

```r
# Install devtools if not already installed
install.packages("devtools")

# To ensure the vignette HTML files are bundled into the package, install omoptrend as follow: 
devtools::install(build_vignettes = TRUE)
```

## Key Files
* `R/`: Folder with the core functions
    * `extractPatients(connection, cdmSchema)`: Extract patient counts by condition and time
    * `plotTrend(data, byMonth = FALSE)`: Plot condition trends by year or month
    * `launchShinyApp(data)`: Launch interactive Shiny app
    * `launchShinyAppDemo()`: Launch interactive Shiny app. A helper function that automates the workflow
    * `validateConnection`, `validateDialect`, `validateExtractedData`: Validation helper scripts
* `inst/sql/get_condition_counts.sql`: SQL template for extracting condition counts (used in extractPatients(...) function)
* `inst/shiny/app/app.R`: Shiny app source code
* `inst/scripts/codeToRun.R`: Example script showing end‑to‑end workflow
* `vignettes/codeToRun.Rmd`: Vignette demonstrating package usage
* `tests/`: Unit tests for extractPatients(...) and plotTrend(...)

## Usage

### 1. Extract patients

```r
library(omoptrend)

connectionDetails <- Eunomia::getEunomiaConnectionDetails()
conn <- DatabaseConnector::connect(connectionDetails)

df <- extractPatients(connection = conn, cdmSchema = "main")
head(df, 10)

DatabaseConnector::disconnect(conn)
```

### 2. Plot trends

```r
# Plot yearly trends
plotTrend(data = df)

# Plot monthly trends
plotTrend(data = df, byMonth = TRUE)
```

### 3. Launch Shiny app

```r
# Launch with with pre-extracted data
launchShinyApp(data = df)

# Launch automated workflow (use this if step 1 is skipped)
launchShinyAppDemo()
```

## Example

The package includes a script `inst/scripts/codeToRun.R` that demonstrates the full workflow:

```r
source(system.file("scripts", "codeToRun.R", package = "omoptrend"))
```

## Testing

Run unit tests with:

```r
library(testthat)
test_package("omoptrend")
```

## Vignettes

`omoptrend` includes vignette that demonstrate `codeToRun.R` workflow (extracting patient counts, plotting condition trends, and launching the Shiny app).

### Viewing vignettes 

Browse available vignette with:

```r
browseVignettes("omoptrend")
```

or

```r
vignette("codeToRun", package = "omoptrend")
```

## Shiny App

The Shiny app in omoptrend is launched via the function `launchShinyApp(data)`, where `data` is the data frame returned by `extractPatients(...)`. The helper function `launchShinyAppDemo()` automates the workflow: connects to Eunomia, extracts patients, and launches the app in one command.

### What the app contains

* __Condition selector (pulldown menu)__: Lets the user choose a condition from the dataset.
* __Time granularity toggle (checkbox)__: Switches between yearly (byMonth = FALSE) and monthly (byMonth = TRUE) views.
* __Calendar input (dateRangeInput)__: Allows the user to filter the dataset by a specific date range, so they can zoom in on a subset of years or months.
* __Dynamic plot__: Uses `plotTrend(...)` internally to render the frequency of the selected condition over the chosen time frame. The plot refreshes automatically when the user changes the condition, time granularity, or calendar range.

### How to use

Please refer to the section __Usage__.

## Additional information

For additional information, questions, suggestions, please contact the authors.

## Authors

[Anastasiia Hryhorzhevska](https://www.linkedin.com/in/ahryhorzhevska/)
