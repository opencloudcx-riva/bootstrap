# Developed by RIVA Solutions Inc 2022.  Authorized Use Only

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
  # source = "../module-eks-aws"
  source = "git::ssh://git@github.com/opencloudcx-riva/module-eks-aws?ref=ext%2Ffpac-eks"

  name             = "opencloudcx-${random_string.scope.result}"
  cluster_version  = var.kubernetes_version
  region           = var.aws_region
  worker_groups    = var.worker_groups
  map_users        = var.eks_map_users
  map_roles        = var.eks_map_roles
  write_kubeconfig = var.write_kubeconfig
  stack            = "specvpctst"

  # aws_certificate_arn         = var.aws_certificate_arn
  # aws_certificate_cname       = var.aws_certificate_cname
  # aws_certificate_cname_value = var.aws_certificate_cname_value

  create_vpc = true
  vpc_id     = "" #var.vpc_id

  # private_subnets = var.private_subnets
  # public_subnets  = var.public_subnets
  # cidr            = var.cidr


  dns_zone = var.dns_zone

  additional_namespaces = ["util"]

  # kubernetes_dockerhub_secret_name     = var.kubernetes_dockerhub_secret_name
  # kubernetes_secret_dockerhub_username = var.kubernetes_secret_dockerhub_username
  # kubernetes_secret_dockerhub_password = var.kubernetes_secret_dockerhub_password
  # kubernetes_secret_dockerhub_email    = var.kubernetes_secret_dockerhub_email
}

# module "grafana_monitoring" {
#   # source = "../module-grafana-monitoring"
#   source = "git::ssh://git@github.com/opencloudcx-riva/module-grafana-monitoring?ref=demo"

#   prometheus_endpoint = "http://prometheus-server.opencloudcx.svc.cluster.local"

#   providers = {
#     kubernetes = kubernetes.mgmt,
#     grafana    = grafana.mgmt
#   }

#   depends_on = [
#     module.opencloudcx-aws-mgmt,
#   ]
# }

output "aws_eks_cluster_endpoint_mgmt" {
  value = module.opencloudcx-aws-mgmt.aws_eks_cluster_endpoint
}

output "aws_eks_cluster_auth_token_mgmt" {
  value = nonsensitive(module.opencloudcx-aws-mgmt.aws_eks_cluster_auth_token)
}

output "aws_eks_cluster_ca_certificate_mgmt" {
  value = module.opencloudcx-aws-mgmt.aws_eks_cluster_ca_certificate
}
