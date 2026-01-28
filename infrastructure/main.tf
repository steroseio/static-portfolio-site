locals {
  common_tags = merge(
    {
      tf_managed = "true"
    },
    var.tags,
  )
}

module "site_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 5.9"

  bucket = var.site_bucket_name

  acl                            = "private"
  force_destroy                  = false
  block_public_acls              = true
  block_public_policy            = true
  ignore_public_acls             = true
  restrict_public_buckets        = true
  control_object_ownership       = true
  object_ownership               = "BucketOwnerPreferred"
  attach_elb_log_delivery_policy = false

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning = {
    status = true
  }

  tags = local.common_tags
}
