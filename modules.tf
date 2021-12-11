



##########################################



# data "kubernetes_secret" "grafana_admin" {
#   metadata {
#     name      = "grafana-secret"
#     namespace = "opencloudcx"
#   }

#   depends_on = [
#     module.opencloudcx-aws-mgmt
#   ]
# }

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

# module "drupal" {
#   # source = "../module-drupal"
#   source = "git::ssh://git@github.com/OpenCloudCX/module-drupal?ref=develop"

#   dns_zone     = var.dns_zone
#   namespace    = "develop"
#   drupal_email = "anorris@rivasolutionsinc.com"

#   providers = {
#     kubernetes = kubernetes.mgmt,
#     helm       = helm.mgmt
#   }

#   depends_on = [
#     module.opencloudcx-aws-mgmt,
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