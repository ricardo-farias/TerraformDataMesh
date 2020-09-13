module "vpc" {
  source          = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=tags/v2.23.0"
  name            = "${var.project_name}-${var.environment}-vpc"
  cidr            = "10.0.0.0/16"
  azs             = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]

  # enable_nat_gateway     = true
  # single_nat_gateway     = true
  # one_nat_gateway_per_az = false

  tags = {
    Terraform = "true"
    Project = var.project_name    
    Environment = var.environment
  }

  private_subnet_tags = {
  "kubernetes.io/cluster/${var.project_name}-${var.environment}-cluster" = "shared"
  "kubernetes.io/role/internal-elb"                                              = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.project_name}-${var.environment}-cluster" = "shared"
    "kubernetes.io/role/elb"                                                       = "1"
  }

}