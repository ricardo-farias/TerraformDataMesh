resource "aws_elasticache_subnet_group" "airflow_redis_subnet_group" {
  name       = var.project_name
  subnet_ids = var.subnets
}

resource "aws_elasticache_cluster" "celery_backend" {
  cluster_id = var.project_name
  engine = "redis"
  engine_version = "5.0.6"
  node_type = var.instance_type
  num_cache_nodes = 1
  port = "6379"
  subnet_group_name = aws_elasticache_subnet_group.airflow_redis_subnet_group.id
  security_group_ids = var.security_groups
}