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

variable "domain_name" {
  description = "Apex domain name that Route53 will manage (e.g. example.com)."
  type        = string
  default     = "sterose.io"
}

variable "tags" {
  description = "Additional tags to apply to all resources."
  type        = map(string)
  default     = {}
}

variable "counter_table_name" {
  description = "Name of the DynamoDB table used for the visitor counter."
  type        = string
  default     = "steroseio-visitor-counter"
}

variable "counter_partition_key" {
  description = "Partition key value used for the singleton visitor counter item."
  type        = string
  default     = "site-total"
}

variable "counter_lambda_function_name" {
  description = "Name of the Lambda function that increments and returns the visitor counter."
  type        = string
  default     = "steroseio-visitor-counter"
}

variable "counter_lambda_runtime" {
  description = "Runtime used by the visitor counter Lambda function."
  type        = string
  default     = "python3.12"
}

variable "counter_lambda_timeout_seconds" {
  description = "Timeout for the visitor counter Lambda function."
  type        = number
  default     = 3
}

variable "counter_api_name" {
  description = "Name of the API Gateway HTTP API for the visitor counter."
  type        = string
  default     = "steroseio-visitor-counter-api"
}

variable "counter_allowed_origins" {
  description = "Optional list of CORS origins for the counter API. Leave empty to use sensible defaults."
  type        = list(string)
  default     = []
}
