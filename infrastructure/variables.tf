variable "aws_region" {
  description = "AWS region to deploy the infrastructure."
  type        = string
  default     = "eu-west-1"
}

variable "domain_name" {
  description = "Primary domain name used for the static site bucket."
  type        = string
  default     = "sterose.io"
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}
