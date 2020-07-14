output "redis_id" {
  value = aws_elasticache_cluster.celery_backend.cache_nodes.0.id
}

output "redis_address" {
  value = aws_elasticache_cluster.celery_backend.cache_nodes.0.address
}

output "redis_port" {
  value = aws_elasticache_cluster.celery_backend.cache_nodes.0.port
}

output "elastic_cache" {
  value = aws_elasticache_cluster.celery_backend
}