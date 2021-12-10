module "opencloudcx-aws-mgmt" {
  source = "../module-opencloudcx-aws"
  # source = "git::ssh://git@github.com/OpenCloudCX/module-opencloudcx-aws?ref=develop"

  name             = "opencloudcx-mgmt-${random_string.scope.result}"
  cluster_version  = var.kubernetes_version
  region           = var.aws_region
  worker_groups    = var.worker_groups
  map_users        = var.eks_map_users
  map_roles        = var.eks_map_roles
  write_kubeconfig = var.write_kubeconfig
  stack            = "mgmt"


  dns_zone = "mgmt.${var.dns_zone}"

  kubernetes_dockerhub_secret_name     = var.kubernetes_dockerhub_secret_name
  kubernetes_secret_dockerhub_username = var.kubernetes_secret_dockerhub_username
  kubernetes_secret_dockerhub_password = var.kubernetes_secret_dockerhub_password
  kubernetes_secret_dockerhub_email    = var.kubernetes_secret_dockerhub_email
}

