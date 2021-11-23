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

