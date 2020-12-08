output "eks_cluster_endpoint"{
  value = module.eks-cluster.cluster_endpoint
}

output "eks_cluster_arn" {
  value = module.eks-cluster.cluster_arn
}

output "eks_cluster_id" {
  value = module.eks-cluster.cluster_id
}