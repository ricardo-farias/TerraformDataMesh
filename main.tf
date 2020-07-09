module "data-bucket" {
  source = "./modules/s3"
  bucket_name = var.data_bucket_name

  force_destroy = false
}

module "logging-bucket" {
  source = "./modules/s3"
  bucket_name = var.logging_bucket_name

  force_destroy = true
}

module "athena-bucket" {
  source = "./modules/s3"
  bucket_name = var.athena_bucket_name

  force_destroy = false
}

module "glue" {
  source = "./modules/glue"
  database_name = var.database_name
}

module "security" {
  source = "./modules/security"
}

module "iam" {
  source = "./modules/iam"
  athena_bucket_name = module.athena-bucket.bucket_name
  data_bucket_name = module.data-bucket.bucket_name
  glue_catalog_id = module.glue.glue_catalog_id
  glue_catalog_name = module.glue.glue_database_name
}

//module "emr" {
//  source = "./modules/emr"
//  applications = var.applications
//  core_instance_count = var.core_instance_count
//  core_instance_type = var.core_instance_type
//  emr_ec2_instance_profile = module.iam.emr_ec2_instance_profile
//  emr_master_security_group = module.security.emr_master_security_group
//  emr_service_role = module.iam.emr_service_role
//  emr_slave_security_group = module.security.emr_slave_security_group
//  key_name = var.key_name
//  logging_bucket = module.logging-bucket.bucket_id
//  master_instance_type = var.master_instance_type
//  name = var.name
//  release_label = var.release_label
//  subnet_id = module.security.subnet_id
//}