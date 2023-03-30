# create dataset
resource "google_bigquery_dataset" "gcp_bigquery_dataset" {
  dataset_id  = var.output.dataset_id
  description = var.output.dataset_description
}

# create tables
resource "google_bigquery_table" "gcp_bigquery_tables" {
  for_each = zipmap([for table in var.output.tables : table.name], var.output.tables)

  dataset_id          = google_bigquery_dataset.gcp_bigquery_dataset.dataset_id
  table_id            = each.value.name
  deletion_protection = !each.value.delete_on_destroy

  schema = file(each.value.bigquery_schema)

  dynamic "time_partitioning" {
    # only add content block if found in output_time_partitioning
    for_each = contains(keys(var.output_tables_time_partitioning), each.key) ? [1] : []

    content {
      type  = var.output_tables_time_partitioning[each.key].type
      field = var.output_tables_time_partitioning[each.key].field
    }
  }
}

# grant read access to consumers
data "google_iam_policy" "data_product_consumer" {
  binding {
    role    = "roles/bigquery.dataViewer"
    members = var.output.grant_access
  }
}

resource "google_bigquery_table_iam_policy" "policy" {
  for_each = google_bigquery_table.gcp_bigquery_tables

  project     = each.value.project
  dataset_id  = each.value.dataset_id
  table_id    = each.value.table_id
  policy_data = data.google_iam_policy.data_product_consumer.policy_data
}
