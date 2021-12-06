# output "jenkins_secret" {
#     value = nonsensitive(module.opencloudcx-aws-dev.jenkins_secret)
# }

# output "jenkins_url" {
#     value = module.opencloudcx-aws-dev.jenkins_url
# }

output "aws_eks_cluster_endpoint" {
  value = module.opencloudcx-aws-dev.aws_eks_cluster_endpoint
}

output "aws_eks_cluster_auth_token" {
  value = nonsensitive(module.opencloudcx-aws-dev.aws_eks_cluster_auth_token)
}

output "aws_eks_cluster_ca_certificate" {
  value = module.opencloudcx-aws-dev.aws_eks_cluster_ca_certificate
}

output "jenkins_password" {
  value = module.opencloudcx-aws-dev.jenkins_secret
  sensitive = true
}

output "grafana_password" {
  value = module.opencloudcx-aws-dev.grafana_secret
  sensitive = true
}