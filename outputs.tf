# Developed by RIVA Solutions Inc 2022.  Authorized Use Only

# output "jenkins_password" {
#   value = nonsensitive(module.opencloudcx-aws-mgmt.jenkins_secret)
# }

# output "grafana_password" {
#   value = nonsensitive(module.opencloudcx-aws-mgmt.grafana_secret)
# }

# output "sonarqube_password" {
#   value = nonsensitive(module.opencloudcx-aws-mgmt.sonarqube_secret)
# }

# output "sonarqube_key" {
#   value = module.opencloudcx-aws-mgmt.sonarqube_key
# }

# output "kubernetes_cluster_endpoint" {
#   value = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_endpoint
# }

# output "kubernetes_auth_token" {
#   value = nonsensitive(module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_auth_token)
# }

# output "kubernetes_cluster_ca_certificate" {
#   value = module.opencloudcx-aws-eks-mgmt.aws_eks_cluster_ca_certificate
# }

output "jenkins_url" {
  value = format("https://%s", module.opencloudcx-config.jenkins_url)
}

output "sonarqube_url" {
  value = format("https://%s", module.opencloudcx-config.sonarqube_url)
}

output "dashboard_url" {
  value = format("https://%s", module.opencloudcx-config.dashboard_url)
}

output "spinnaker_url" {
  value = format("https://%s", module.opencloudcx-config.spinnaker_url)
}

output "spinnaker_gate_url" {
  value = format("https://%s", module.opencloudcx-config.spinnaker_gate_url)
}
