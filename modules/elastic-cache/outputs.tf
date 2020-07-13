output "redis_endpoint" {
  value = aws_elasticache_cluster.celery_backend.configuration_endpoint
}

output "redis_dns" {
  value = aws_elasticache_cluster.celery_backend.cluster_address
}

output "redis_id" {
  value = aws_elasticache_cluster.celery_backend.id
}