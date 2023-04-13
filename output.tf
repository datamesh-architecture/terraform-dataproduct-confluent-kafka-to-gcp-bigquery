output "project" {
  value       = var.gcp.project
  description = "The Google Cloud project"
}

output "dataset_id" {
  value       = google_bigquery_dataset.gcp_bigquery_dataset.dataset_id
  description = "The id of the Google BigQuery dataset"
}

output "table_ids" {
  value       = [for table in google_bigquery_table.gcp_bigquery_tables : table.table_id]
  description = "The ids of all created Google BigQuery tables"
}

output "discovery_endpoint" {
  value       = google_cloudfunctions2_function.function.service_config[0].uri
  description = "The URI of the generated discovery endpoint"
}
