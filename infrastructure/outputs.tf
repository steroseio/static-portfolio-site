output "bucket_id" {
  description = "ID of the S3 bucket hosting the site."
  value       = module.site_bucket.s3_bucket_id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket hosting the site."
  value       = module.site_bucket.s3_bucket_arn
}

output "bucket_domain_name" {
  description = "Regional endpoint for the S3 bucket."
  value       = module.site_bucket.s3_bucket_bucket_regional_domain_name
}

output "cloudfront_distribution_domain_name" {
  description = "Domain name assigned to the CloudFront distribution."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "visitor_counter_table_name" {
  description = "DynamoDB table name used by the visitor counter API."
  value       = aws_dynamodb_table.visitor_counter.name
}

output "visitor_counter_lambda_name" {
  description = "Lambda function name for visitor counter requests."
  value       = aws_lambda_function.counter.function_name
}

output "visitor_counter_api_endpoint" {
  description = "Base HTTP API endpoint URL for the visitor counter service."
  value       = aws_apigatewayv2_api.counter.api_endpoint
}

output "visitor_counter_api_counter_url" {
  description = "Direct GET endpoint that increments and returns the visitor counter."
  value       = "${aws_apigatewayv2_api.counter.api_endpoint}/counter"
}
