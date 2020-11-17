locals {
  bucket_config_data_yaml = yamldecode(file("./modules/s3/bucket-config.yaml"))
}

module "vpc" {
  source = "./modules/vpc"
  project_name = var.project_name
  environment = var.environment
  aws_region = var.aws_region
}

module "glue" {
  source = "./modules/glue"
  database_name = var.glue_db_name
  project_name = var.project_name
  environment = var.environment
  lake_formation_admin = var.lake_formation_admin
  covid_domain_location_arn = "${var.project_name}-${var.environment}-${local.bucket_config_data_yaml.source_domain[0].bucket}"
  bike_domain_location_arn = "${var.project_name}-${var.environment}-${local.bucket_config_data_yaml.source_domain[1].bucket}"
}

module "ecr" {
  source = "./modules/ecr"
  project_name = var.project_name
  environment = var.environment
}

module "iam" {
  source = "./modules/iam"
  athena_bucket_name = "${var.project_name}-${var.environment}-${local.bucket_config_data_yaml.non_source_domain[0].bucket}"
  covid_data_bucket_name = "${var.project_name}-${var.environment}-${local.bucket_config_data_yaml.source_domain[0].bucket}"
  glue_catalog_id = module.glue.glue_catalog_id
  glue_catalog_name = module.glue.glue_database_name
  citi_bike_bucket_name = "${var.project_name}-${var.environment}-${local.bucket_config_data_yaml.source_domain[1].bucket}"
  project_name = var.project_name
  environment = var.environment
  aws_region = var.aws_region
}

module "rds" {
  source = "./modules/rds"
  db_name = "postgres"
  username = "airflow"
  password = file("rds_password.txt")
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  project_name = var.project_name
  environment = var.environment
}

module "eks" {
  source = "./modules/eks"
  subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
  project_name = var.project_name
  environment = var.environment
}

module "s3" {
  source = "./modules/s3"
  project_name = var.project_name
  environment = var.environment
}
