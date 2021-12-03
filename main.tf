provider "aws" {
  region = "us-east-1"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "random_string" "scope" {
  length  = 4
  upper   = false
  number  = false
  special = false
}

