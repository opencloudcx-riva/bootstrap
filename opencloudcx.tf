# module "opencloudcx-config" {

#   depends_on = [
#     module.opencloudcx-aws-eks-mgmt
#   ]

#   source = "../module-new-ocx-aws"

#   providers = {
#     kubernetes = kubernetes.mgmt
#     helm       = helm.mgmt
#   }

#   random_seed   = random_string.scope.result
#   stack         = module.opencloudcx-aws-eks-mgmt.stack
#   dns_zone      = var.dns_zone

#   kubernetes_dockerhub_secret_name     = var.kubernetes_dockerhub_secret_name
#   kubernetes_secret_dockerhub_username = var.kubernetes_secret_dockerhub_username
#   kubernetes_secret_dockerhub_password = var.kubernetes_secret_dockerhub_password
#   kubernetes_secret_dockerhub_email    = var.kubernetes_secret_dockerhub_email

#   cert_manager_helm_chart_version  = "1.8.0"
#   spinnaker_helm_chart_version     = "2.2.7"
#   ingress_helm_chart_version       = "4.0.19"
#   k8s_dashboard_helm_chart_version = "5.4.1"
#   jenkins_helm_chart_version       = "3.11.10"
#   keycloak_helm_chart_version      = "7.1.14"
#   grafana_helm_chart_version       = "6.26.3"
#   influxdb_helm_chart_version      = "4.0.10"
#   sonarqube_helm_chart_version     = "3.0.0+296"
#   prometheus_helm_chart_version    = "15.8.4"

# }