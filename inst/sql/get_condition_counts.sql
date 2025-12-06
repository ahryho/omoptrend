-- get_condition_counts.sql
-- Extract distinct patient counts per condition by year and month across OMOP CDM
-- Parameters:
--   @cdmSchema: schema (or database.schema) containing OMOP CDM tables

SELECT
  c.condition_concept_id,
  v.concept_name,
  c.condition_start_datetime,
  YEAR(COALESCE(c.condition_start_date, CAST(c.condition_start_datetime AS DATE))) AS year,
  MONTH(COALESCE(c.condition_start_date, CAST(c.condition_start_datetime AS DATE))) AS month,
  COUNT(DISTINCT c.person_id) AS patient_count
FROM @cdmSchema.condition_occurrence c
JOIN @cdmSchema.concept v
  ON v.concept_id = c.condition_concept_id
GROUP BY
  c.condition_concept_id,
  v.concept_name,
  YEAR(COALESCE(c.condition_start_date, CAST(c.condition_start_datetime AS DATE))),
  MONTH(COALESCE(c.condition_start_date, CAST(c.condition_start_datetime AS DATE)))
ORDER BY year, month, patient_count DESC;