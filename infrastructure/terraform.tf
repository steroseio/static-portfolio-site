terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">= 1.10"

  backend "s3" {
    bucket         = "steroseio-tf-state"
    key            = "static-portfolio-site/infrastructure.tfstate"
    region         = "us-east-1"
    dynamodb_table = "steroseio-tf-lock"
    encrypt        = true
  }
}
