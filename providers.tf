terraform {
  required_version = ">=1.3.5"
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = ">= 1.35"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.59.0"
    }
    archive = {
      source = "hashicorp/archive"
      version = ">=2.4.0"
    }
    local = {
      source = "hashicorp/local"
      version = ">=2.4.0"
    }
  }
}
