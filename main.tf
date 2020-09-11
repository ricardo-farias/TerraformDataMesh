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
}

# module "security" {
#   source = "./modules/security"
# }

module "ecr" {
   source = "./modules/ecr"
   project_name = var.project_name
   environment = var.environment
}

module "iam" {
  source = "./modules/iam"
  athena_bucket_name = module.s3.athena-bucket
  covid_data_bucket_name = module.s3.covid-data-bucket
  glue_catalog_id = module.glue.glue_catalog_id
  glue_catalog_name = module.glue.glue_database_name
  citi_bike_bucket_name = module.s3.bike-bucket
  project_name = var.project_name
  environment = var.environment
}

 module "rds" {
   source = "./modules/rds"
   name = "postgres"
   username = "airflow"
   password = "airflow123456"
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

# module "cloudwatch" {
#   source = "./modules/cloudwatch"
# }

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

module "s3" {
  source = "./modules/s3"
   project_name = var.project_name
   environment = var.environment
}

# module "load_balancer" {
#   source = "./modules/load-balancer"
#   internal = false
#   listener_port = "8080"
#   listener_protocol = "HTTP"
#   listener_type = "forward"
#   load_balancer_name = "airflow-load-balancer"
#   load_balancer_type = "application"
#   security_groups = [module.security.load_balancer_security_group_id]
#   subnets = [module.security.public_subnet_1_id, module.security.public_subnet_2_id]
#   target_group_name = "airflow-webserver"
#   target_group_port = "8080"
#   target_group_protocol = "HTTP"
#   target_group_vpc = module.security.vpc_id
#   matcher = "200,302"
# }
