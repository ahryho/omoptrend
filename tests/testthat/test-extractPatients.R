# tests/testthat/test-extractPatients.R
test_that("extractPatients returns expected structure and values", {
  # Avoids running heavy DB tests on CRAN
  skip_on_cran()
  skip_if_not_installed("Eunomia")

  # Get Eunomia connection
  connectionDetails <- Eunomia::getEunomiaConnectionDetails()
  conn <- DatabaseConnector::connect(connectionDetails)
  
  # Disconnect the connection to avoid leaks
  on.exit(DatabaseConnector::disconnect(conn), add = TRUE)

  df <- omoptrend::extractPatients(connection = conn, cdmSchema = "main")

  # Basic structure
  expect_s3_class(df, "data.frame")
  expect_true(all(c("condition_concept_id",
                    "concept_name",
                    "year",
                    "month",
                    "patient_count") %in% names(df)))

  # Types
  expect_type(df$year, "integer")
  expect_type(df$month, "integer")
  expect_type(df$patient_count, "integer")

  # Values
  expect_true(all(df$patient_count >= 0))
  expect_true(all(df$year >= 0))
  expect_true(all(df$month >= 1 & df$month <= 12))
})
