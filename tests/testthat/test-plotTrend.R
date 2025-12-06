# tests/testthat/test-plotTrend.R
test_that("plotTrend produces ggplot objects for year and month views", {
  # Avoids running heavy DB tests on CRAN
  skip_on_cran()
  skip_if_not_installed("Eunomia")

  # Get Eunomia connection
  connectionDetails <- Eunomia::getEunomiaConnectionDetails()
  conn <- DatabaseConnector::connect(connectionDetails)
  
  # Disconnect the connection to avoid leaks
  on.exit(DatabaseConnector::disconnect(conn), add = TRUE)

  df <- omoptrend::extractPatients(connection = conn, cdmSchema = "main")

  # Yearly plot
  plotYear <- omoptrend::plotTrend(data = df, byMonth = FALSE)
  expect_s3_class(plotYear, "ggplot")

  # Monthly plot
  plotMonth <- omoptrend::plotTrend(data = df, byMonth = TRUE)
  expect_s3_class(plotMonth, "ggplot")
})

test_that("plotTrend aggregates correctly by year", {
  skip_on_cran()
  skip_if_not_installed("Eunomia")

  connectionDetails <- Eunomia::getEunomiaConnectionDetails()
  conn <- DatabaseConnector::connect(connectionDetails)
  on.exit(DatabaseConnector::disconnect(conn), add = TRUE)

  df <- omoptrend::extractPatients(connection = conn, cdmSchema = "main")

  # Aggregate manually by year
  manual <- aggregate(patient_count ~ concept_name + year, data = df, FUN = sum)

  # Extract plotted data from plotTrend
  p <- omoptrend::plotTrend(data = df, byMonth = FALSE)
  plotted <- ggplot2::layer_data(p)

  # Check that years in plot match manual aggregation
  expect_true(all(manual$year %in% plotted$x))
})
