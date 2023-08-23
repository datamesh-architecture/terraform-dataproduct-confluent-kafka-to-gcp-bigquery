# Data Mesh Terraform module "Confluent Kafka to GCP BigQuery"

This Terraform module provisions the necessary services to provide a data product on the Google Cloud Platform.

![Overview](https://raw.githubusercontent.com/datamesh-architecture/datamesh-architecture.com/main/images/terraform-dataproduct-confluent-kafka-to-gcp-bigquery.png)

## Services

* Confluent Kafka
* Google BigQuery
* Google Cloud Functions

## Prerequisites

### Google Cloud APIs

You need to enable some APIs of your Google Cloud project. E.g. enable it with the [gcloud](https://cloud.google.com/sdk/gcloud) command line tool:
```shell
gcloud services enable <SERVICE_NAME>
```

For the Kafka to BigQuery Connector you need:
- BigQuery API (`bigquery.googleapis.com`)
- Identity and Access Management (IAM) API (`iam.googleapis.com`)

In addition, you need some APIs for the discovery endpoint, which runs on Cloud Functions:

- Cloud Functions API (`cloudfunctions.googleapis.com`)
- Cloud Run Admin API (`run.googleapis.com`)
- Artifact Registry API (`artifactregistry.googleapis.com`)
- Cloud Build API (`cloudbuild.googleapis.com`)
- Cloud Storage API (`storage.googleapis.com`)


### Google Cloud IAM permissions
You need use a service account with an [IAM role](https://cloud.google.com/iam/docs/understanding-roles) which grants the following permissions:  

```
run.services.getIamPolicy
run.services.setIamPolicy
run.services.getIamPolicy
bigquery.datasets.create
bigquery.datasets.get
bigquery.models.delete
bigquery.routines.delete
bigquery.tables.getIamPolicy
cloudfunctions.functions.create
cloudfunctions.functions.delete
cloudfunctions.functions.get
cloudfunctions.functions.getIamPolicy
cloudfunctions.functions.update
cloudfunctions.operations.get
compute.disks.create
compute.disks.get
compute.globalOperations.get
compute.instances.create
compute.instances.delete
compute.instances.get
compute.instances.setTags
compute.networks.create
compute.networks.delete
compute.networks.get
compute.subnetworks.use
compute.subnetworks.useExternalIp
compute.zoneOperations.get
compute.zones.get
iam.serviceAccountKeys.create
iam.serviceAccountKeys.delete
iam.serviceAccountKeys.get
iam.serviceAccounts.actAs
iam.serviceAccounts.create
iam.serviceAccounts.delete
iam.serviceAccounts.get
storage.buckets.create
storage.buckets.delete
storage.objects.get
storage.objects.list
```

## Usage

```hcl
module "kafka_to_bigquery" {
  source = "git@github.com:datamesh-architecture/terraform-dataproduct-confluent-kafka-to-gcp-bigquery.git"
  
  domain = "<data_product_domain>"
  name   = "<data_product_name>"
  input = [
    {
      topic  = "<topic_name>"
      format = "<topic_format>"
    }
  ]

  output = {
    data_access      = ["<gcp_principal>"]
    discovery_access = ["<gcp_principal>"]
    tables = [
      {
        id                = "<table_name>" # must be equal to corresponding topic
        schema            = "<table_schema_path>"
        delete_on_destroy = false # set true for development or testing environments
      }
    ]
  }
  
  # optional settings for time based partitioning, if needed
  output_tables_time_partitioning = {
    "stock" = {
      type  = "<time_partitioning_type>" # DAY, HOUR, MONTH, YEAR
      field = "<time_partitioning_field>" # optional, uses consumption time if null
    }
  }
}
```

Note: You can put all kind of [principals](https://cloud.google.com/iam/docs/overview#concepts_related_identity) into `data_access` and `discovery_access`.

## Endpoint data

The module creates an RESTful endpoint via Google Cloud Functions (e.g. https://info-xxxxxxxxxx-xx.a.run.app). This endpoint can be used as an input for another data product or to retrieve information about this data product.

```json
{
    "domain": "<data_product_domain>",
    "name": "<data_product_name>",
    "output": {
        "locations": ["<big_query_table_uri>"]
    }
}
```

## Examples

Examples, how to use this module, can be found in a separate [GitHub repository](https://github.com/datamesh-architecture/terraform-datamesh-dataproduct-examples).

## Authors

This terraform module is maintained by [Stefan Negele](https://www.innoq.com/en/staff/stefan-negele/), [Christine Koppelt](https://www.innoq.com/de/staff/christine-koppelt/), [Jochen Christ](https://www.innoq.com/en/staff/jochen-christ/), and [Simon Harrer](https://www.innoq.com/en/staff/dr-simon-harrer/).

## License

MIT License.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_confluent"></a> [confluent](#requirement\_confluent) | >= 1.35 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 4.59.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | n/a |
| <a name="provider_confluent"></a> [confluent](#provider\_confluent) | >= 1.35 |
| <a name="provider_google"></a> [google](#provider\_google) | >= 4.59.0 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [confluent_api_key.app-consumer-kafka-api-key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_api_key.app-producer-kafka-api-key](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/api_key) | resource |
| [confluent_connector.sink](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/connector) | resource |
| [confluent_kafka_acl.app-connector-create-on-dlq-lcc-topics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-connector-create-on-error-lcc-topics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-connector-create-on-success-lcc-topics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-connector-describe-on-cluster](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-connector-read-on-connect-lcc-group](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-connector-read-on-target-topic](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-connector-write-on-dlq-lcc-topics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-connector-write-on-error-lcc-topics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-connector-write-on-success-lcc-topics](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-consumer-read-on-group](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-consumer-read-on-topic](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_kafka_acl.app-producer-write-on-topic](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/kafka_acl) | resource |
| [confluent_service_account.app-connector](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/service_account) | resource |
| [confluent_service_account.app-consumer](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/service_account) | resource |
| [confluent_service_account.app-producer](https://registry.terraform.io/providers/confluentinc/confluent/latest/docs/resources/service_account) | resource |
| [google_bigquery_dataset.gcp_bigquery_dataset](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset) | resource |
| [google_bigquery_dataset_iam_binding.kafka_sink_dataset_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset_iam_binding) | resource |
| [google_bigquery_table.gcp_bigquery_tables](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table) | resource |
| [google_bigquery_table_iam_binding.table_iam_binding](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table_iam_binding) | resource |
| [google_cloud_run_service_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_policy) | resource |
| [google_cloudfunctions2_function.function](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions2_function) | resource |
| [google_service_account.kafka_sink_gcp_service_account](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_service_account_key.kafka_sink_gcp_service_account_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account_key) | resource |
| [google_storage_bucket.bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.function_source](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [local_file.info_lambda_index_js](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.info_lambda_package_json](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [archive_file.info_lambda_archive](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |
| [google_iam_policy.allow_invocations](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/iam_policy) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain"></a> [domain](#input\_domain) | The domain of the data product | `string` | n/a | yes |
| <a name="input_gcp"></a> [gcp](#input\_gcp) | project: The GCP project of your data product<br>region: The GCP region where your data product should be located | <pre>object({<br>    project = string<br>    region  = string<br>  })</pre> | n/a | yes |
| <a name="input_input"></a> [input](#input\_input) | topic: Name of the Kafka topic which should be processed<br>format: Currently only 'JSON' is supported | <pre>list(object({<br>    topic  = string<br>    format = string<br>  }))</pre> | n/a | yes |
| <a name="input_kafka"></a> [kafka](#input\_kafka) | Information and credentials about/from the Kafka cluster | <pre>object({<br>    environment = object({<br>      id = string<br>    })<br>    cluster = object({<br>      id            = string<br>      api_version   = string<br>      kind          = string<br>      rest_endpoint = string<br>    })<br>    credentials = object({<br>      api_key_id     = string<br>      api_key_secret = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the data product | `string` | n/a | yes |
| <a name="input_output"></a> [output](#input\_output) | dataset\_id: The id of the dataset in which your data product will exist<br>dataset\_description: A description of the dataset<br>grant\_access: List of users with access to the data product<br>discovery\_access: List of users with access to the discovery endpoint<br>region: The google cloud region in which your data product should be created<br>tables.id: The table\_id of your data product, which will be used to create a BigQuery table. Must be equal to the corresponding kafka topic name.<br>tables.schema: The path to the products bigquery schema<br>tables.delete\_on\_destroy: 'true' if the BigQuery table should be deleted if the terraform resource gets destroyed. Use with care! | <pre>object({<br>    data_access      = list(string)<br>    discovery_access = list(string)<br>    tables = list(object({<br>      id                = string<br>      schema            = string<br>      delete_on_destroy = bool<br>    }))<br>  })</pre> | n/a | yes |
| <a name="input_output_tables_time_partitioning"></a> [output\_tables\_time\_partitioning](#input\_output\_tables\_time\_partitioning) | You can configure time based partitioning by passing an object which has the tables id as its key.<br>type: Possible values are: DAY, HOUR, MONTH, YEAR<br>field: The field which should be used for partitioning. Falls back to consumption time, if null is passed. | <pre>map(object({<br>    type  = string<br>    field = string<br>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dataset_id"></a> [dataset\_id](#output\_dataset\_id) | The id of the Google BigQuery dataset |
| <a name="output_discovery_endpoint"></a> [discovery\_endpoint](#output\_discovery\_endpoint) | The URI of the generated discovery endpoint |
| <a name="output_project"></a> [project](#output\_project) | The Google Cloud project |
| <a name="output_table_ids"></a> [table\_ids](#output\_table\_ids) | The ids of all created Google BigQuery tables |
<!-- END_TF_DOCS -->
