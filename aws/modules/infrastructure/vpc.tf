data "aws_availability_zones" "available" {
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name            = "meltano-${var.meltano_environment}"
  cidr            = var.vpc_cidr
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets
  azs             = data.aws_availability_zones.available.names

  enable_nat_gateway         = true
  single_nat_gateway         = true
  manage_default_route_table = true

  # support for private endpoints via dns, required by eks
  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/cluster/meltano-${var.meltano_environment}" = "shared"
    "kubernetes.io/role/elb"                                   = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/meltano-${var.meltano_environment}" = "shared"
    "kubernetes.io/role/internal-elb"                          = "1"
  }

  tags = {
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

locals {
  vpc = {
    name            = "meltano-${var.meltano_environment}"
    cidr            = var.vpc_cidr
    vpc_id          = module.vpc.vpc_id
    public_subnets  = module.vpc.public_subnets
    private_subnets = module.vpc.private_subnets
  }
}