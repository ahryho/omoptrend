# R programmer for Health Data Science

Welcome to the round of the recruitment process for R programmer for Health Data Science

## Exercise

We would like you to complete a short take-home exercise to help us evaluate the R skills needed for the position.

Familiarize yourself with the [OMOP CDM](https://ohdsi.github.io/CommonDataModel/cdm54.html) format and the [Eunomia R package](https://github.com/OHDSI/Eunomia)

The exercise involves the following:

Create an R package that exports the following functions:

1. `extractPatients(connection)`

This function should take a database connection as input, and extract counts of all conditions by year and month from the condition occurence table in the OMOP CDM database. The function should be able to do this for different sql dialects using the [SqlRender R package](https://ohdsi.github.io/SqlRender/). It should return a data.frame with the data needed for the `plotTrend` function.

2. `plotTrend(data, byMonth = FALSE)` 

`plotTrend` takes output from the `extractPatients` function as input and returns a plot with the number of patients per year (default) or per month for each condition in "data".

3. `launchShinyApp()`

Create a simple shiny app should have a pulldown menu to filter the data by condition and a checkbox (boolean input) for the `byMonth` parameter in `plotTrend`. The app should then plot the frequency of the selected condition by the selected time frame (Year or Month). `launchShinyApp` should start the shiny app contained in the R package.

Creating the Shiny App will give you extra points.

We would like you to make an R package that does this and provides a simple unit test using (https://testthat.r-lib.org/) of the `extractPatients` and `plotTrend` functions. Unit tests can run on the SQLite OMOP CDM database in the Eunomia R package.

In the submitted package there should be a file named codeToRun.R which provides an example of running the functions in the package on an OMOP CDM database. this file should call the functions `extractPatients`, `plotTrend` (by year), `plotTrend` (by month), and `launchShinyApp`.

The codeToRun.R script should run without errors.

## Evaluation
You will be evaluated on the critera below. 

### Completeness and correctness: up to 5 points:

- All three tasks are completed and return correct results. 4 pts
- Two tasks are completed and return correct results. 3 pts
- At least two tasks are completed There may be bugs or errors in the calculations, but works end to end. 2 pts
- At least one task is completed, possibly with errors but works end to end. 1 pt
- Anything else. 0 pts

### Code style and conventions: up to 4 points:

- Code is logically organized and clearly commented. Style follows the HADES style guideline https://ohdsi.github.io/Hades/codeStyle.html. Code is fully documented specifying inputs, outputs and with a clear description of what the functions do. There are at least some tests or assertions and exception handling (if necessary). 4 pts
- Code is logically organized and clearly commented.  Style follows the HADES style guideline https://ohdsi.github.io/Hades/codeStyle.html. Code is fully documented specifying inputs, outputs and with a clear description of what the functions do. 3 pts
- Code is logically organized, but documentation is inconsistent or confusing. 2 pts
- Code is disorganized and hard to follow. Inconsistent and arbitrary style. 1 pt
- Anything else. 0 pts

## Submitting a solution
Please commit all code into this repository using git, create a zip file and return via email, by or before **Tuesday, December 9 2025**.
