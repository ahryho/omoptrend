# omoptrend

_This package is an exercise for Health Data Science position at EMC._

An R package for exploring patient condition trends in OMOP CDM databases. It provides functions to extract patient counts, visualize trends, and launch an interactive Shiny app.

## The scope of the exercise

Familiarize yourself with the [OMOP CDM](https://ohdsi.github.io/CommonDataModel/cdm54.html) format and the [Eunomia R package](https://github.com/OHDSI/Eunomia)

The exercise involves the following:

Create an R package that exports the following functions:

1. `extractPatients(connection)`

This function should take a database connection as input, and extract counts of all conditions by year and month from the condition occurence table in the OMOP CDM database. The function should be able to do this for different sql dialects using the [SqlRender R package](https://ohdsi.github.io/SqlRender/). It should return a data.frame with the data needed for the `plotTrend` function.

2. `plotTrend(data, byMonth = FALSE)` 

`plotTrend` takes output from the `extractPatients` function as input and returns a plot with the number of patients per year (default) or per month for each condition in "data".

3. `launchShinyApp()`

Create a simple shiny app should have a pulldown menu to filter the data by condition and a checkbox (boolean input) for the `byMonth` parameter in `plotTrend`. The app should then plot the frequency of the selected condition by the selected time frame (Year or Month). `launchShinyApp` should start the shiny app contained in the R package.

We would like you to make an R package that does this and provides a simple unit test using (https://testthat.r-lib.org/) of the `extractPatients` and `plotTrend` functions. Unit tests can run on the SQLite OMOP CDM database in the Eunomia R package.

In the submitted package there should be a file named codeToRun.R which provides an example of running the functions in the package on an OMOP CDM database. this file should call the functions `extractPatients`, `plotTrend` (by year), `plotTrend` (by month), and `launchShinyApp`.

## Installation

Clone the repository and install from source:

```r
# Install devtools if not already installed
install.packages("devtools")

# Install omoptrend with vignettes
devtools::install(build_vignettes = TRUE)
```

## Key Files
* `R/`: Folder with the core functions:
    * `extractPatients(connection, cdmSchema)`: Extract patient counts by condition and time
    * `plotTrend(data, byMonth = FALSE)`: Plot condition trends by year or month
    * `launchShinyApp(data)`: Launch interactive Shiny app
    * `launchShinyAppDemo()`: Launch interactive Shiny app
    * `validateConnection`, `validateDialect`, `validateExtractedData`: Validation helper scripts
* `scripts`: Folder containing scripts for exploring the raw data (_interviews.json_) and testing that Gemini connection works
* `src`: Folder containing main scripts for the analysis 
    * `src.main.py`: Main script for running the code
    * `src.extractor.py`: Script for extracting the information from the input data and 


## Vignettes

`omoptrend` includes vignette that demonstrate `codeToRun.R` workflow (extracting patient counts, plotting condition trends, and launching the Shiny app).

### Building vignettes 

To ensure the vignette HTML files are bundled into the package, build the vignettes as follow:

```r
devtools::install(build_vignettes = TRUE)
```

### Viewing vignettes 

Once installed, you can browse available vignette with:

```r
browseVignettes("omoptrend")
```

or

```r
vignette("codeToRun", package = "omoptrend")
```