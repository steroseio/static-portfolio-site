provider "aws" {
  region = var.aws_region
}

provider "aws" {
  alias  = "cloudfront_cert"
  region = "us-east-1"
}

provider "cloudflare" {}
