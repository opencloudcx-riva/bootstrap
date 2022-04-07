# Developed by RIVA Solutions Inc 2022.  Authorized Use Only

output "jenkins_password" {
  value = nonsensitive(module.opencloudcx-aws-mgmt.jenkins_secret)
}

output "grafana_password" {
  value = nonsensitive(module.opencloudcx-aws-mgmt.grafana_secret)
}

output "sonarqube_password" {
  value = nonsensitive(module.opencloudcx-aws-mgmt.sonarqube_secret)
}

# output "sonarqube_key" {
#   value = module.opencloudcx-aws-mgmt.sonarqube_key
# }