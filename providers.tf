terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.33.0"
    }
  }
}

provider "aws" {
  region                      = "us-west-2"
  skip_requesting_account_id  = true
  skip_credentials_validation = true
}