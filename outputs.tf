//output "id" {
//  value = module.emr.id
//}
//
//output "name" {
//  value = module.emr.name
//}
//
//output "master_public_dns" {
//  value = module.emr.master_public_dns
//}

output "public_subnet-1" {
  value = module.security.public_subnet_1_id
}

output "public_subnet-2" {
  value = module.security.public_subnet_2_id
}

output "redis_dns" {
  value = module.elastic_cache.redis_address
}

output "load_balancer" {
  value = module.load_balancer.load_balancer_dns
}

output "ecr_url" {
  value = module.ecr.airflow-ecr-repo-url
}