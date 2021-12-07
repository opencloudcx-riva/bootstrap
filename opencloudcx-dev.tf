locals {
  prefix = "dev"
  name   = "opencloudcx-${local.prefix}-${random_string.scope.result}"
  tags   = { env = "dev" }
  region = var.aws_region
}

module "opencloudcx-aws-dev" {
  # source = "../module-opencloudcx-aws"
  source = "git::ssh://git@github.com/OpenCloudCX/module-opencloudcx-aws?ref=develop"

  name             = local.name
  cluster_version  = var.kubernetes_version
  region           = var.aws_region
  worker_groups    = var.worker_groups
  map_users        = var.eks_map_users
  map_roles        = var.eks_map_roles
  write_kubeconfig = var.write_kubeconfig

  dns_zone = var.dns_zone
}