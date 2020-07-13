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
  internal = false
  listener_port = "8080"
  listener_protocol = "HTTP"
  listener_type = "forward"
  load_balancer_name = "airflow-load-balancer"
  load_balancer_type = "application"
  security_groups = [module.security.load_balancer_security_group_id]
  subnets = [module.security.public_subnet_1_id, module.security.public_subnet_2_id]
  target_group_name = "airflow-webserver"
  target_group_port = "8080"
  target_group_protocol = "HTTP"
  target_group_vpc = module.security.vpc_id
  matcher = "200,302"
}

module "elastic_cache" {
  source = "./modules/elastic-cache"

  instance_type = "cache.t2.micro"
  project_name = "airflow-redis"
  security_groups = [module.security.redis_security_group_id]
  subnets = [module.security.public_subnet_1_id, module.security.public_subnet_2_id]
}

//
//module "ecs" {
//  source = "./modules/ecs"
//  cluster_id = module.ecr.airflow-ecr-repo-id
//  fernet_key = file("fernet.txt")
//  image = module.ecr.airflow-ecr-repo-url
//  launch_type = "FARGATE"
//  load_balancer_name = module.load_balancer.load_balancer_name
//  network_mode = "awsvpc"
//  private_subnet = module.security.private_subnet_id
//  public_subnet = module.security.public_subnet_id
//  redis_host = "redis.kyh3fa.0001.use2.cache.amazonaws.com"
//  requires_compatibilities = ["FARGATE"]
//  task_execution_arn = module.iam.ecs_task_execution_arn
//  redis_security_group_id = module.security.redis_security_group_id
//  scheduler_security_group_id = module.security.scheduler_security_group_id
//  webserver_security_group_id = module.security.webserver_security_group_id
//  worker_security_group_id = module.security.worker_security_group_id
//}

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