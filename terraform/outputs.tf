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

/* ***** S3 ***** */
output "s3_bucket_names" {
  value = module.s3.bucket_list_map_result
}

/* ***** ECR ***** */
output "airflow_ecr_base_repo_url" {
  value = module.ecr.airflow-ecr-base-repo-url
}

output "airflow_ecr_dags_repo_url" {
  value = module.ecr.airflow-ecr-dags-repo-url
}

/* ***** RDS ***** */
output "rds_endpoint" {
  value = module.rds.rds_address
}

/* ***** EKS ***** */
output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}

output "eks_cluster_id" {
  value = module.eks.eks_cluster_id
}

output "eks_cluster_arn" {
  value = module.eks.eks_cluster_arn
}
