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

/* ***** VPC ***** */
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

/* ***** ECR ***** */
output "platform-shared-ecr-repo-url" {
  value = module.ecr.platform-shared-ecr-repo-url
}

output "covid-ecr-repo-url" {
  value = module.ecr.covid-ecr-repo-url
}

output "citi-bike-ecr-repo-url" {
  value = module.ecr.citi-bike-ecr-repo-url
}