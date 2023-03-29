variable "confluent" {
  type = object({
    cloud_api_key    = string
    cloud_api_secret = string
  })
  sensitive   = true
  description = "Confluent (Cloud) related credentials"
}

variable "kafka" {
  type = object({
    environment = object({
      id = string
    })
    cluster = object({
      id            = string
      api_version   = string
      kind          = string
      rest_endpoint = string
    })
    credentials = object({
      api_key_id     = string
      api_key_secret = string
    })
  })
  sensitive   = true
  description = "Information and credentials about/from the Kafka cluster"
}

variable "gcp" {
  type = object({
    credentials = string
    project     = string
    dataset     = string
  })
  description = <<EOT
credentials: Your GCP credentials JSON
project: The GCP project of your data product
dataset: The BigQuery dataset in which the big query tables are located
EOT
}

variable "domain" {
  type        = string
  description = "The domain of the data product"
}

variable "name" {
  type        = string
  description = "The name of the data product"
}

variable "input" {
  type = list(object({
    topic  = string
    format = string
  }))
  description = <<EOT
topic: Name of the Kafka topic which should be processed
format: Currently only 'JSON' is supported
EOT
}
