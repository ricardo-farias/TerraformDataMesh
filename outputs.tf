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

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "nat_public_ips" {
  value = module.vpc.nat_public_ips
}

# output "redis_dns" {
#   value = module.elastic_cache.redis_address
# }

# output "load_balancer" {
#   value = module.load_balancer.load_balancer_dns
# }

# output "ecr_url" {
#   value = module.ecr.airflow-ecr-repo-url
# }