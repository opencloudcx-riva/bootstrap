# Developed by RIVA Solutions Inc 2022.  Authorized Use Only

provider "aws" {
  region     = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "random_string" "scope" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

