locals {
  prefix = "dev"
  name   = "opencloudcx-${local.prefix}-${random_string.scope.result}"
  tags   = { env = "dev" }
  region = "us-east-1"
}

module "opencloudcx-aws-dev" {
  source = "../module-opencloudcx-aws"

  name             = local.name
  cluster_version  = var.kubernetes_version
  region           = "us-east-1"
  map_users        = var.eks_map_users
  map_roles        = var.eks_map_roles
  write_kubeconfig = var.write_kubeconfig

  dns_zone = var.dns_zone
}