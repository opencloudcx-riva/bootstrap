# Developed by RIVA Solutions Inc 2022.  Authorized Use Only

terraform {
  required_providers {
    aws = "~> 3.74"
    grafana = {
      source  = "grafana/grafana"
      version = "~> 1.16.0"
    }
  }
}




