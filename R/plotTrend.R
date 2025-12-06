#' Plot condition patient counts by year or aggregated month
#'
#' @description
#' The funciton takes output from the `extractPatients` function as input and returns a plot with the number of patients 
#' per year (default) or per month for each condition in "data".
#' 
#' @param data data.frame from extractPatients()
#'   Must include columns: condition_concept_id, concept_name, year, month, patient_count
#' @param byMonth Logical. TRUE = plot by month (aggregated across years),
#'   FALSE = plot by year (aggregated across months).
#'
#' @return ggplot object showing patient count trends
#'
#' @examples
#' \dontrun{
#' p <- plotTrend(data = df, byMonth = FALSE)
#' print(p)
#' }
#'
#' @examples
#' \dontrun{
#' connection_details <- Eunomia::getEunomiaConnectionDetails()
#' conn <- connect(connection_details)
#' 
#' df <- extractPatients(connection = conn, cdmSchema = "main")
#'
#' # Plot trends by YEAR
#' plotTrend(data = df)
#' 
#' # Plot trends by MONTH
#' plotTrend(data = df, byMonth = TRUE)
#' }
#' 
#' @export
plotTrend <- function(data, byMonth = FALSE) {
  # Validate that the input data has the required structure
  validateExtractedData(data)

  if (byMonth) {
    # MONTH VIEW -------------------------------
    
    # Convert month column to integer (drivers may return character)
    data$month <- as.integer(data$month)

    # Define month labels (Jan–Dec) and map numeric months to factors
    monthNames <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun",
                    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
    data$month_label <- factor(monthNames[data$month],
                               levels = monthNames,
                               ordered = TRUE)

    # Aggregate patient counts across all years by month and condition
    agg <- stats::aggregate(
      patient_count ~ concept_name + month_label,
      data = data,
      FUN = sum
    )

    # Plot aggregated monthly counts
    ggplot2::ggplot(agg,
                    ggplot2::aes(x = month_label,
                                 y = patient_count,
                                 color = concept_name,
                                 group = concept_name)) +
      ggplot2::geom_line(linewidth = 0.8) +   # line for each condition
      ggplot2::geom_point(size = 1.6) +       # points at each month
      ggplot2::labs(
        x = "Month",
        y = "Distinct patients (aggregated across years)",
        color = "Condition",
        title = "Condition trends by month"
      ) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        legend.position = "bottom",
        plot.title = ggplot2::element_text(face = "bold")
      )

  } else {
    # YEARLY VIEW -------------------------------

    # Convert year column to integer
    data$year <- as.integer(data$year)

    # Aggregate patient counts across all months by year and condition
    agg <- stats::aggregate(
      patient_count ~ concept_name + year,
      data = data,
      FUN = sum
    )

    # Determine a step size for x-axis breaks to avoid overlap
    yr <- sort(unique(agg$year))
    range <- diff(range(yr))
    step <- if (range >= 20) 5 else if (range >= 10) 2 else 1
    breaks <- seq(min(yr, na.rm = TRUE), max(yr, na.rm = TRUE), by = step)

    # Plot aggregated yearly counts
    ggplot2::ggplot(agg,
                    ggplot2::aes(x = year,
                                 y = patient_count,
                                 color = concept_name,
                                 group = concept_name)) +
      ggplot2::geom_line(linewidth = 0.8) +   # line for each condition
      ggplot2::geom_point(size = 1.6) +       # points at each year
      ggplot2::scale_x_continuous(breaks = breaks) +
      ggplot2::labs(
        x = "Year",
        y = "Distinct patients",
        color = "Condition",
        title = "Condition trends by year"
      ) +
      ggplot2::theme_minimal(base_size = 12) +
      ggplot2::theme(
        legend.position = "bottom",
        plot.title = ggplot2::element_text(face = "bold")
      )
  }
}