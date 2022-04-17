# Developed by RIVA Solutions Inc 2022.  Authorized Use Only

provider "kubernetes" {
  alias                  = "mgmt"
  host                   = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_endpoint
  token                  = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_auth_token
  cluster_ca_certificate = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_ca_certificate
}

provider "helm" {
  alias = "mgmt"
  kubernetes {
    host                   = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_endpoint
    token                  = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_auth_token
    cluster_ca_certificate = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_ca_certificate
  }
}

module "opencloudcx-aws-eks-mgmt" {

  source = "../module-eks-aws"
  # source = "git::ssh://git@github.com/opencloudcx-riva/module-eks-aws?ref=ext%2Ffpac-eks"

  name             = "opencloudcx-${random_string.scope.result}"
  cluster_version  = var.kubernetes_version
  region           = var.aws_region
  worker_groups    = var.worker_groups
  map_users        = var.eks_map_users
  map_roles        = var.eks_map_roles
  write_kubeconfig = var.write_kubeconfig
  stack            = "mgmt"

  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  vpc_id = module.vpc.vpc_id

  dns_zone = var.dns_zone

  additional_namespaces = ["util"]
}

output "aws_eks_cluster_endpoint_mgmt" {
  value = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_endpoint
}

output "aws_eks_cluster_auth_token_mgmt" {
  value = nonsensitive(module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_auth_token)
}

output "aws_eks_cluster_ca_certificate_mgmt" {
  value = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_ca_certificate
}
