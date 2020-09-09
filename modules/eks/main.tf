# Cluster IAM role

resource "aws_iam_role" "eks_cluster" {
  name = "${var.eks_cluster_name}-cluster-${var.environment}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}
resource "aws_iam_role_policy_attachment" "aws_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.eks_cluster.name}"
}
resource "aws_iam_role_policy_attachment" "aws_eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.eks_cluster.name}"
}

# EKS Cluster Security Group
resource "aws_security_group" "eks_cluster" {
  name        = var.cluster_sg_name
  description = "Cluster communication with worker nodes"
  vpc_id      = var.vpc_id
tags = {
    Name = var.cluster_sg_name
  }
}
resource "aws_security_group_rule" "cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 443
  type                     = "ingress"
}
resource "aws_security_group_rule" "cluster_outbound" {
  description              = "Allow cluster API Server to communicate with the worker nodes"
  from_port                = 1024
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "egress"
}


# EKS Worker Node Group Security Group
resource "aws_security_group" "eks_nodes" {
  name        = var.nodes_sg_name
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc_id
egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
    Name                                            = var.nodes_sg_name
    "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
  }
}
resource "aws_security_group_rule" "nodes" {
  description              = "Allow nodes to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_nodes.id
  to_port                  = 65535
  type                     = "ingress"
}
resource "aws_security_group_rule" "nodes_inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_nodes.id
  source_security_group_id = aws_security_group.eks_cluster.id
  to_port                  = 65535
  type                     = "ingress"
}



# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.eks_cluster_name
  role_arn = "${aws_iam_role.eks_cluster.arn}"
vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    subnet_ids = var.eks_cluster_subnet_ids
  }
# Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    "aws_iam_role_policy_attachment.aws_eks_cluster_policy",
    "aws_iam_role_policy_attachment.aws_eks_service_policy"
  ]
}