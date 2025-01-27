terraform {
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "6.17.0"
        }
    }
}

provider "google" {
    credentials = file(var.gcp_key)
    project = var.gcp_project
    region  = var.gcp_region
}

resource "google_storage_bucket" "terraform-jrs-gcs-bucket" {
  name          = var.gcs_bucket_name
  location      = var.gcp_region
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = var.bigquery_dataset_name
  description                 = "The description of dataset"
  location                    = var.gcp_region
}