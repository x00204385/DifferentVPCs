provider "aws" {
  region  = var.region
  profile = "tud-admin"
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.39"
    }
  }
}
