provider "kubernetes" {
  alias                  = "dev"
  host                   = module.opencloudcx-aws-dev.aws_eks_cluster_endpoint
  token                  = module.opencloudcx-aws-dev.aws_eks_cluster_auth_token
  cluster_ca_certificate = module.opencloudcx-aws-dev.aws_eks_cluster_ca_certificate
}

provider "helm" {
  alias = "dev"
  kubernetes {
    host                   = module.opencloudcx-aws-dev.aws_eks_cluster_endpoint
    token                  = module.opencloudcx-aws-dev.aws_eks_cluster_auth_token
    cluster_ca_certificate = module.opencloudcx-aws-dev.aws_eks_cluster_ca_certificate
  }
}

module "opencloudcx-aws-dev" {
  # source = "../module-eks-aws"
  source = "git::ssh://git@github.com/OpenCloudCX/module-eks-aws?ref=demo"

  name             = "opencloudcx-${random_string.scope.result}"
  cluster_version  = var.kubernetes_version
  region           = var.aws_region
  worker_groups    = var.worker_groups
  map_users        = var.eks_map_users
  map_roles        = var.eks_map_roles
  write_kubeconfig = var.write_kubeconfig
  stack            = "dev"

  # aws_certificate_arn = var.aws_certificate_arn
  private_subnets = ["10.1.10.0/24", "10.1.20.0/24", "10.1.30.0/24"]
  public_subnets  = ["10.1.40.0/24", "10.1.50.0/24", "10.1.60.0/24"]
  cidr            = "10.1.0.0/16"

  additional_namespaces = ["develop"]

  dns_zone = var.dns_zone
}

module "code-server" {
  # source = "../module-code-server"
  source = "git::ssh://git@github.com/OpenCloudCX/module-code-server?ref=demo"

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
  # source = "../module-mariadb"
  source = "git::ssh://git@github.com/OpenCloudCX/module-mariadb?ref=demo"

  dns_zone  = "dev.${var.dns_zone}"
  namespace = "develop"
  prefix    = "dev"

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

output "aws_eks_cluster_endpoint_dev" {
  value = module.opencloudcx-aws-dev.aws_eks_cluster_endpoint
}

output "aws_eks_cluster_auth_token_dev" {
  value = nonsensitive(module.opencloudcx-aws-dev.aws_eks_cluster_auth_token)
}

output "aws_eks_cluster_ca_certificate_dev" {
  value = module.opencloudcx-aws-dev.aws_eks_cluster_ca_certificate
}
