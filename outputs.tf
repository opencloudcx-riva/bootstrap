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
  value = nonsensitive(module.opencloudcx-aws-mgmt.jenkins_secret)
}

output "grafana_password" {
  value = nonsensitive(module.opencloudcx-aws-mgmt.grafana_secret)
}