# codeToRun.R
# Example end-to-end usage of the omoptrend package on Eunomia OMOP CDM

library(Eunomia)
library(omoptrend)
library(DatabaseConnector)

# Get Eunomia connection
print("------- Establishing Eunomia Connection -------")
connectionDetails <- Eunomia::getEunomiaConnectionDetails()
conn <- connect(connectionDetails)
cdmSchema <- "main"

# 1. Extract data
df <- extractPatients(connection = conn, cdmSchema = cdmSchema)
print("------- The top 10 records of the extracted data -------")
print(head(df, 10))

# Clean up
DatabaseConnector::disconnect(conn)

# 2. Plot trends by year
print("------- Plot trends by YEAR -------")
plotTrend(data = df, byMonth = FALSE)

# 3. Plot trends by month
print("------- Plot trends by MONTH -------")
plotTrend(data = df, byMonth = TRUE)

# 4) Launch Shiny app
launchShinyAppDemo()