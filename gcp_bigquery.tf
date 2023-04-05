# create dataset
resource "google_bigquery_dataset" "gcp_bigquery_dataset" {
  dataset_id  = "source"
  description = "Raw data consumed from Confluent Kafka."
  location    = var.gcp.region
}

# create tables
resource "google_bigquery_table" "gcp_bigquery_tables" {
  for_each = zipmap([for table in var.output.tables : table.id], var.output.tables)

  dataset_id          = google_bigquery_dataset.gcp_bigquery_dataset.dataset_id
  table_id            = each.value.id
  deletion_protection = !each.value.delete_on_destroy

  schema = file(each.value.schema)

  dynamic "time_partitioning" {
    # only add content block if found in output_time_partitioning
    for_each = contains(keys(var.output_tables_time_partitioning), each.key) ? [1] : []

    content {
      type  = var.output_tables_time_partitioning[each.key].type
      field = var.output_tables_time_partitioning[each.key].field
    }
  }
}

# service account for the sink
resource "google_service_account" "kafka_sink_gcp_service_account" {
  account_id   = "confluent-kafka-bigquery-sink"
  display_name = "Confluent Kafka Big Query Sink"
}

resource "google_service_account_key" "kafka_sink_gcp_service_account_key" {
  service_account_id = google_service_account.kafka_sink_gcp_service_account.name
}

# grant read access to consumers on table level
resource "google_bigquery_table_iam_binding" "table_iam_binding" {
  for_each = google_bigquery_table.gcp_bigquery_tables

  project    = each.value.project
  dataset_id = each.value.dataset_id
  table_id   = each.value.table_id
  members    = var.output.data_access
  role       = "roles/bigquery.dataViewer"
}

# read + write access to kafka sink service account on dataset level
resource "google_bigquery_dataset_iam_binding" "kafka_sink_dataset_iam_binding" {
  dataset_id = google_bigquery_dataset.gcp_bigquery_dataset.dataset_id
  members    = [google_service_account.kafka_sink_gcp_service_account.member]
  role       = "roles/bigquery.dataEditor"
}
