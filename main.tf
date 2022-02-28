terraform {

  required_version = "~> 0.12.31"

  required_providers {
    aws  = "~> 3.74.1"
  }
}

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

