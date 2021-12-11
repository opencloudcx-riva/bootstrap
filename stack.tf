terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.16.0"
    }
  }
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

provider "kubernetes" {
  alias                  = "nonprod"
  host                   = module.opencloudcx-aws-nonprod.aws_eks_cluster_endpoint
  token                  = module.opencloudcx-aws-nonprod.aws_eks_cluster_auth_token
  cluster_ca_certificate = module.opencloudcx-aws-nonprod.aws_eks_cluster_ca_certificate
}

provider "helm" {
  alias = "nonprod"
  kubernetes {
    host                   = module.opencloudcx-aws-nonprod.aws_eks_cluster_endpoint
    token                  = module.opencloudcx-aws-nonprod.aws_eks_cluster_auth_token
    cluster_ca_certificate = module.opencloudcx-aws-nonprod.aws_eks_cluster_ca_certificate
  }
}

provider "grafana" {
  url                  = "https://grafana.mgmt.${var.dns_zone}"
  insecure_skip_verify = true
  auth                 = "admin:${module.opencloudcx-aws-mgmt.grafana_secret}"
  org_id               = 1
  alias                = "mgmt"
}