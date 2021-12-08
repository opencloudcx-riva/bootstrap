dns_zone = "<dns zone>"

eks_map_users = [{
  groups   = ["system:masters"]
  userarn  = "arn:aws:iam::<account number>:user/<iam username>"
  username = "<username>"
}]

eks_map_roles = [{
  groups   = ["system:masters"]
  rolearn  = "arn:aws:iam::<account number>:role/<iam rolename>"
  username = "<username>"
}]

kubernetes_dockerhub_secret_name     = "<dockerhub account reference name>"
kubernetes_secret_dockerhub_username = "<dockerhub username>"
kubernetes_secret_dockerhub_email    = "<dockerhub email>"
