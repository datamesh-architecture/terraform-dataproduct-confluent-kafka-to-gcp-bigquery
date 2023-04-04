terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = ">= 1.35"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.51.0"
    }
  }
}
