terraform {
  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.16.0"
    }
  }
}

provider "kubernetes" {
  host                   = module.opencloudcx-aws-dev.aws_eks_cluster_endpoint
  token                  = module.opencloudcx-aws-dev.aws_eks_cluster_auth_token
  cluster_ca_certificate = module.opencloudcx-aws-dev.aws_eks_cluster_ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = module.opencloudcx-aws-dev.aws_eks_cluster_endpoint
    token                  = module.opencloudcx-aws-dev.aws_eks_cluster_auth_token
    cluster_ca_certificate = module.opencloudcx-aws-dev.aws_eks_cluster_ca_certificate
  }
}

resource "kubernetes_namespace" "develop" {
  metadata {
    name = "develop"
  }

  depends_on = [
    module.opencloudcx-aws-dev
  ]
}

module "code-server" {
  # source = "../module-code-server"
  source = "git::ssh://git@github.com/OpenCloudCX/module-code-server?ref=demo"

  dns_zone  = var.dns_zone
  namespace = "develop"

  providers = {
    kubernetes = kubernetes,
    helm       = helm
  }

  depends_on = [
    module.opencloudcx-aws-dev,
  ]
}

output "codeserver_password" {
  value = nonsensitive(module.code-server.module_secret)
}

##########################################

provider "grafana" {
  url                  = "https://grafana.${var.dns_zone}"
  insecure_skip_verify = true
  auth                 = "admin:${module.opencloudcx-aws-dev.grafana_secret}"
  org_id               = 1
}

data "kubernetes_secret" "grafana_admin" {
  metadata {
    name      = "grafana-secret"
    namespace = "opencloudcx"
  }

  depends_on = [
    module.opencloudcx-aws-dev
  ]
}

module "grafana_monitoring" {
  # source = "../module-grafana-monitoring"
  source = "git::ssh://git@github.com/OpenCloudCX/module-grafana-monitoring?ref=demo"

  prometheus_endpoint = "http://prometheus-server.opencloudcx.svc.cluster.local"

  providers = {
    kubernetes = kubernetes,
    grafana    = grafana
  }

  depends_on = [
    module.opencloudcx-aws-dev,
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
  source = "git::ssh://git@github.com/OpenCloudCX/module-drupal?ref=demo"

  dns_zone     = var.dns_zone
  namespace    = "develop"
  drupal_email = "anorris@rivasolutionsinc.com"

  providers = {
    kubernetes = kubernetes,
    helm       = helm
  }

  depends_on = [
    module.opencloudcx-aws-dev,
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