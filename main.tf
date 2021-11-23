provider "aws" {
  region = "us-east-1"
}

resource "random_string" "scope" {
  length  = 4
  upper   = false
  lower   = false
  special = false
}

