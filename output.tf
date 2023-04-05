output "project" {
  value = var.gcp.project
}

output "dataset_id" {
  value = google_bigquery_dataset.gcp_bigquery_dataset.dataset_id
}

output "table_ids" {
  value = [for table in google_bigquery_table.gcp_bigquery_tables : table.table_id]
}

output "discovery_endpoint" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
}
