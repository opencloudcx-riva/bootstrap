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

resource "kubernetes_namespace" "develop" {
  metadata {
    name = "develop"
  }

  depends_on = [
    module.opencloudcx-aws-mgmt
  ]
}

module "code-server" {
  # source = "../module-code-server"
  source = "git::ssh://git@github.com/OpenCloudCX/module-code-server?ref=develop"

  dns_zone  = var.dns_zone
  namespace = "develop"

  providers = {
    kubernetes = kubernetes.mgmt,
    helm       = helm.mgmt
  }

  depends_on = [
    module.opencloudcx-aws-mgmt,
  ]
}

output "codeserver_password" {
  value = nonsensitive(module.code-server.module_secret)
}

##########################################

provider "grafana" {
  url                  = "https://grafana.${var.dns_zone}"
  insecure_skip_verify = true
  auth                 = "admin:${module.opencloudcx-aws-mgmt.grafana_secret}"
  org_id               = 1
}

data "kubernetes_secret" "grafana_admin" {
  metadata {
    name      = "grafana-secret"
    namespace = "opencloudcx"
  }

  depends_on = [
    module.opencloudcx-aws-mgmt
  ]
}

module "grafana_monitoring" {
  # source = "../module-grafana-monitoring"
  source = "git::ssh://git@github.com/OpenCloudCX/module-grafana-monitoring?ref=develop"

  prometheus_endpoint = "http://prometheus-server.opencloudcx.svc.cluster.local"

  providers = {
    kubernetes = kubernetes.mgmt,
    grafana    = grafana
  }

  depends_on = [
    module.opencloudcx-aws-mgmt,
  ]
}

##########################################

# module "anchore" {
#   source = "../module-anchore"
#   # source = "git::ssh://git@github.com/OpenCloudCX/module-anchore?ref=develop"

#   dns_zone    = var.dns_zone
#   namespace   = "jenkins"
#   admin_email = "anorris@rivasolutionsinc.com"

#   providers = {
#     kubernetes = kubernetes,
#     helm       = helm
#   }

#   depends_on = [
#     module.opencloudcx-aws-dev,
#   ]
# }

module "drupal" {
  # source = "../module-drupal"
  source = "git::ssh://git@github.com/OpenCloudCX/module-drupal?ref=develop"

  dns_zone     = var.dns_zone
  namespace    = "develop"
  drupal_email = "anorris@rivasolutionsinc.com"

  providers = {
    kubernetes = kubernetes.mgmt,
    helm       = helm.mgmt
  }

  depends_on = [
    module.opencloudcx-aws-mgmt,
  ]
}

# module "mariadb" {
#   source = "../module-mariadb"
#   # source = "git::ssh://git@github.com/OpenCloudCX/module-mariadb?ref=develop"

#   dns_zone     = var.dns_zone
#   namespace    = "develop"

#   providers = {
#     kubernetes = kubernetes,
#     helm       = helm
#   }

#   depends_on = [
#     module.opencloudcx-aws-dev,
#   ]
# }

# module "postgresql" {
#   source = "../module-postgres"
#   # source = "git::ssh://git@github.com/OpenCloudCX/module-postgres?ref=develop"

#   dns_zone     = var.dns_zone
#   namespace    = "develop"

#   providers = {
#     kubernetes = kubernetes,
#     helm       = helm
#   }

#   depends_on = [
#     module.opencloudcx-aws-dev,
#   ]
# }