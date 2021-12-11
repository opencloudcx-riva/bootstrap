module "opencloudcx-aws-nonprod" {
  source = "../module-eks-aws"
  # source = "git::ssh://git@github.com/OpenCloudCX/module-opencloudcx-aws?ref=develop"

  name             = "opencloudcx-${random_string.scope.result}"
  cluster_version  = var.kubernetes_version
  region           = var.aws_region
  worker_groups    = var.worker_groups
  map_users        = var.eks_map_users
  map_roles        = var.eks_map_roles
  write_kubeconfig = var.write_kubeconfig
  stack            = "nonprod"

  private_subnets = ["10.2.10.0/24", "10.2.20.0/24", "10.2.30.0/24"]
  public_subnets  = ["10.2.40.0/24", "10.2.50.0/24", "10.2.60.0/24"]
  cidr            = "10.2.0.0/16"

  dns_zone = "nonprod.${var.dns_zone}"
}

module "mariadb-nonprod" {
  source = "../module-mariadb"
  # source = "git::ssh://git@github.com/OpenCloudCX/module-mariadb?ref=develop"

  dns_zone  = "nonprod.${var.dns_zone}"
  namespace    = "default"

  providers = {
    kubernetes = kubernetes.nonprod,
    helm       = helm.nonprod
  }

  depends_on = [
    module.opencloudcx-aws-nonprod,
  ]
}

