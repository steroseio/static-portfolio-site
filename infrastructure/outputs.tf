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
