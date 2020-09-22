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
output "airflow-ecr-base-repo-url" {
  value = module.ecr.airflow-ecr-base-repo-url
}

output "airflow-ecr-dags-repo-url" {
  value = module.ecr.airflow-ecr-dags-repo-url
}

