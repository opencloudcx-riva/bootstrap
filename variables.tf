variable "aws_region" {
  description = "The aws region to deploy the service into"
  type        = string
  default     = "us-east-1"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "dns_zone" {
  type    = string
  default = "opencloudcx.internal"
}

variable "azs" {
  description = "A list of availability zones for the vpc"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "cidr" {
  description = "The vpc CIDR (e.g. 10.0.0.0/16)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "kubernetes_version" {
  description = "The target version of kubernetes"
  type        = string
  default     = "1.21"
}

variable "kubernetes_node_groups" {
  description = "Node group definitions"
  type        = map(any)
  default     = {}
}

variable "eks_map_users" {
  description = "Additional IAM users to add to the aws-auth configmap"
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "worker_groups" {
  type = list(object({
    name                 = string
    instance_type        = string
    asg_desired_capacity = number
  }))
  default = [
    {
      name                 = "worker-group-1"
      instance_type        = "m5.large"
      asg_desired_capacity = 3
    }
  ]
}

variable "eks_map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap"
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "write_kubeconfig" {
  description = "Whether to write a Kubectl config file containing the cluster configuration. Saved to `kubeconfig_output_path`."
  type        = bool
  default     = false
}

variable "kubernetes_dockerhub_secret_name" {
  description = "Kubernetes dockerhub secret name. This is the reference name used within a kaniko pods"
  default     = "dockerhub"
  type        = string
}

variable "kubernetes_secret_dockerhub_username" {
  description = "Kubernetes secret dockerhub username"
  default     = "username"
  type        = string
}

variable "kubernetes_secret_dockerhub_password" {
  description = "Kubernetes secret dockerhub password"
  default     = "password"
  type        = string
}

variable "kubernetes_secret_dockerhub_email" {
  description = "Kubernetes secret dockerhub email"
  default     = "username@spinnaker.internal"
  type        = string
}
