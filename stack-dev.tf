module "opencloudcx-aws-dev" {
  source = "../module-eks-aws"
  # source = "git::ssh://git@github.com/OpenCloudCX/module-opencloudcx-aws?ref=develop"

  name             = "opencloudcx-${random_string.scope.result}"
  cluster_version  = var.kubernetes_version
  region           = var.aws_region
  worker_groups    = var.worker_groups
  map_users        = var.eks_map_users
  map_roles        = var.eks_map_roles
  write_kubeconfig = var.write_kubeconfig
  stack            = "dev"

  private_subnets = ["10.1.10.0/24", "10.1.20.0/24", "10.1.30.0/24"]
  public_subnets  = ["10.1.40.0/24", "10.1.50.0/24", "10.1.60.0/24"]
  cidr            = "10.1.0.0/16"

  additional_namespaces = ["develop"]

  dns_zone = "dev.${var.dns_zone}"
}

module "code-server" {
  # source = "../module-code-server"
  source = "git::ssh://git@github.com/OpenCloudCX/module-code-server?ref=develop"

  dns_zone  = "dev.${var.dns_zone}"
  namespace = "develop"

  providers = {
    kubernetes = kubernetes.dev,
    helm       = helm.dev
  }

  depends_on = [
    module.opencloudcx-aws-dev,
  ]
}

module "mariadb-dev" {
  source = "../module-mariadb"
  # source = "git::ssh://git@github.com/OpenCloudCX/module-mariadb?ref=develop"

  dns_zone  = "dev.${var.dns_zone}"
  namespace    = "develop"

  providers = {
    kubernetes = kubernetes.dev,
    helm       = helm.dev
  }

  depends_on = [
    module.opencloudcx-aws-dev,
  ]
}

output "codeserver_password" {
  value = nonsensitive(module.code-server.module_secret)
}

