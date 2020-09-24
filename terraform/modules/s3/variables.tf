variable "athena_bucket_name" {
  default = "athena-data-mesh-output-bucket"
}
variable "covid_data_bucket_name" {
  default = "data-mesh-covid-domain"
}
variable "citi_bike_data_bucket_name" {
  default = "citi-bike-data-bucket"
}
variable "logging_bucket_name" {
  default = "emr-data-mesh-logging-bucket"
}
variable "project_name" {}
variable "environment" {}
variable "error_folder_name" {}
variable "raw_folder_name" {}
variable "canonical_folder_name" {}