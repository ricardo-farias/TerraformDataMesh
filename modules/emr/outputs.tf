output "id" {
  value = aws_emr_cluster.data-mesh-cluster.id
}

output "name" {
  value = aws_emr_cluster.data-mesh-cluster.name
}

output "master_public_dns" {
  value = aws_emr_cluster.data-mesh-cluster.master_public_dns
}