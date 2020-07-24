module "eks" {
  source                = "terraform-aws-modules/eks/aws"
  cluster_name          = local.cluster_name
  cluster_version       = "1.17"
  subnets               = module.vpc.private_subnets
  vpc_id                = module.vpc.vpc_id
  wait_for_cluster_cmd  = "until curl -sk $ENDPOINT >/dev/null; do sleep 4; done"

  worker_groups = [
    {
      name                          = "worker-group-1"
      instance_type                 = "t2.small"
      asg_desired_capacity          = 1
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
    {
      name                          = "worker-group-2"
      instance_type                 = "t2.small"
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_two.id]
      asg_desired_capacity          = 1
    },
  ]
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
