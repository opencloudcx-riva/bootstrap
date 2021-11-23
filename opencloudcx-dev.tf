locals {
  prefix = "dev"
  name   = "opencloudcx-${local.prefix}-${random_string.scope.result}"
  tags   = { env = "dev" }
  region = "us-east-1"
}

module "opencloudcx-aws-dev" {
  source = "../module-opencloudcx-aws"

  name            = local.name
  cluster_version = var.kubernetes_version
  region          = "us-east-1"

  dns_zone = var.dns_zone
}