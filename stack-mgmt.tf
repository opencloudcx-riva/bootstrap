provider "grafana" {
  url                  = "https://grafana.mgmt.${var.dns_zone}"
  insecure_skip_verify = true
  auth                 = "admin:${module.opencloudcx-aws-mgmt.grafana_secret}"
  org_id               = 1
  alias                = "mgmt"
}

provider "kubernetes" {
  alias                  = "mgmt"
  host                   = module.opencloudcx-aws-mgmt.aws_eks_cluster_endpoint
  token                  = module.opencloudcx-aws-mgmt.aws_eks_cluster_auth_token
  cluster_ca_certificate = module.opencloudcx-aws-mgmt.aws_eks_cluster_ca_certificate
}

provider "helm" {
  alias = "mgmt"
  kubernetes {
    host                   = module.opencloudcx-aws-mgmt.aws_eks_cluster_endpoint
    token                  = module.opencloudcx-aws-mgmt.aws_eks_cluster_auth_token
    cluster_ca_certificate = module.opencloudcx-aws-mgmt.aws_eks_cluster_ca_certificate
  }
}

module "opencloudcx-aws-mgmt" {
  # source = "../module-opencloudcx-aws"
  source = "git::ssh://git@github.com/opencloudcx-riva/module-opencloudcx-aws?ref=demo"

  name             = "opencloudcx-${random_string.scope.result}"
  cluster_version  = var.kubernetes_version
  region           = var.aws_region
  worker_groups    = var.worker_groups
  map_users        = var.eks_map_users
  map_roles        = var.eks_map_roles
  write_kubeconfig = var.write_kubeconfig
  stack            = "mgmt"

  # aws_certificate_arn         = var.aws_certificate_arn
  # aws_certificate_cname       = var.aws_certificate_cname
  # aws_certificate_cname_value = var.aws_certificate_cname_value

  private_subnets = ["10.0.10.0/24", "10.0.20.0/24", "10.0.30.0/24"]
  public_subnets  = ["10.0.40.0/24", "10.0.50.0/24", "10.0.60.0/24"]
  cidr            = "10.0.0.0/16"

  dns_zone = var.dns_zone

  ecr_repos = ["test"]

  kubernetes_dockerhub_secret_name     = var.kubernetes_dockerhub_secret_name
  kubernetes_secret_dockerhub_username = var.kubernetes_secret_dockerhub_username
  kubernetes_secret_dockerhub_password = var.kubernetes_secret_dockerhub_password
  kubernetes_secret_dockerhub_email    = var.kubernetes_secret_dockerhub_email
}

module "grafana_monitoring" {
  # source = "../module-grafana-monitoring"
  source = "git::ssh://git@github.com/opencloudcx-riva/module-grafana-monitoring?ref=demo"

  prometheus_endpoint = "http://prometheus-server.opencloudcx.svc.cluster.local"

  providers = {
    kubernetes = kubernetes.mgmt,
    grafana    = grafana.mgmt
  }

  depends_on = [
    module.opencloudcx-aws-mgmt,
  ]
}

output "aws_eks_cluster_endpoint_mgmt" {
  value = module.opencloudcx-aws-mgmt.aws_eks_cluster_endpoint
}

output "aws_eks_cluster_auth_token_mgmt" {
  value = nonsensitive(module.opencloudcx-aws-mgmt.aws_eks_cluster_auth_token)
}

output "aws_eks_cluster_ca_certificate_mgmt" {
  value = module.opencloudcx-aws-mgmt.aws_eks_cluster_ca_certificate
}
