variable "aws_region" {
  description = "AWS region to deploy the infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "site_bucket_name" {
  description = "Name of the private S3 bucket that stores the built static site."
  type        = string
  default     = "steroseio-static-site"
}

variable "project_name" {
  description = "Identifier used when naming CloudFront and other shared resources."
  type        = string
  default     = "steroseio-portfolio"
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
