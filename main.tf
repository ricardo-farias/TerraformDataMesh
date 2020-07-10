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

module "ecr" {
  source = "./modules/ecr"
  name = "airflow"
}

module "iam" {
  source = "./modules/iam"
  athena_bucket_name = module.athena-bucket.bucket_name
  data_bucket_name = module.data-bucket.bucket_name
  glue_catalog_id = module.glue.glue_catalog_id
  glue_catalog_name = module.glue.glue_database_name
}

resource "aws_ecs_cluster" "airflow" {
  name = var.cluster_name
}

module "load_balancer" {
  source = "./modules/load-balancer"
  internal = ""
  listener_port = "8080"
  listener_protocol = "HTTP"
  listener_type = ""
  load_balancer_name = "airflow-load-balancer"
  load_balancer_type = "Application"
  security_groups = []
  subnets = []
  target_group_name = "airflow-webserver"
  target_group_port = "8080"
  target_group_protocol = "HTTP"
  target_group_vpc = module.security.vpc_id
}


module "ecs-Redis" {
  source = "./modules/ecs"
  command = "webserver"
  cpu = "1024"
  family_name = "Airflow-Redis"
  fernet_key = file("fernet.txt")
  hostPort = "6379"
  image = module.ecr.airflow-ecr-repo-url
  memory = "2048"
  network_mode = "awsvpc"
  redis_host = ""
  requires_compatibilities = []
  task_execution_arn = ""
  assign_public_ip = "true"
  cluster_id = aws_ecs_cluster.airflow.id
  desired_count = ""
  launch_type = "FARGATE"
  security_groups = []
  service_name = "Airflow-Redis"
  subnets = []
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