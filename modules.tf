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
  source = "../module-code-server"

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

# module "anchore" {
#   source = "../module-anchore"

#   dns_zone  = var.dns_zone
#   namespace = "develop"

#   providers = {
#     kubernetes = kubernetes,
#     helm       = helm
#   }

#   depends_on = [
#     module.opencloudcx-aws-dev,
#   ]
# }



module "drupal" {
  source = "../module-drupal"

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