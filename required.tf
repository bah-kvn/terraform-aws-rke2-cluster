terraform {
  required_version = ">=1.2.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.39.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
}

