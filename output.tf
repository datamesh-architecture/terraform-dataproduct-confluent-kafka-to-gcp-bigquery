output "discovery_endpoint" {
  value = google_cloudfunctions2_function.function.service_config[0].uri
}
