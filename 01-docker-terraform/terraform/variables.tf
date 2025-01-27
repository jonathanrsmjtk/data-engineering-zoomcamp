variable "gcp_project" {
    type = string
    description = "The name of your GCP project"
    default = "white-proxy-448817-c5"
}

variable "gcp_region" {
    type = string
    description = "The region of your GCP project"
    default = "asia-southeast2"
}

variable "gcp_key" {
    type = string
    description = "The key dir of your GCP project"
    default = "./secret.json"
}

variable "gcs_bucket_name" {
    type = string
    description = "The name of your GCS bucket"
    default = "terraform-jrs-gcs"
}

variable "bigquery_dataset_name" {
    type = string
    description = "The name of your BQ dataset name"
    default = "terraform_jrs_bq"
}