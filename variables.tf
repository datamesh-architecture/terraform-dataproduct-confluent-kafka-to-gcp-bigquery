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
credentials: Your GCP credentials JSON file location
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

variable "output" {
  type = object({
    grant_access     = list(string)
    discovery_access = list(string)
    region           = string
    tables = list(object({
      name              = string
      bigquery_schema   = string
      delete_on_destroy = bool
    }))
  })
  description = <<EOT
dataset_id: The id of the dataset in which your data product will exist
dataset_description: A description of the dataset
grant_access: List of users with access to the data product
discovery_access: List of users with access to the discovery endpoint
region: The google cloud region in which your data product should be created
tables.name: The name of your dataproduct, which will be used to create a BigQuery table. Must be equal to the corresponding kafka topic name.
tables.bigquery_schema: The path to the products bigquery schema
tables.delete_on_destroy: 'true' if the BigQuery table should be deleted if the terraform resource gets destroyed. Use with care!
EOT
}

variable "output_tables_time_partitioning" {
  type = map(object({
    type  = string
    field = string
  }))
  default     = {}
  description = <<EOT
You can configure time based partitioning by passing an object which has the tables name as its key.
type: Possible values are: DAY, HOUR, MONTH, YEAR
field: The field which should be used for partitioning. Falls back to consumption time, if null is passed.
EOT
}
