# Infrastructure Bootstrap

This Terraform configuration deploys the static site stack (S3 + CloudFront + Cloudflare DNS) used by the Cloud Resume Challenge. Remote state for the configuration lives in an S3 bucket with a DynamoDB table for state locking, so those resources must exist **before** running `terraform init`.

## Prerequisites
- Terraform `>= 1.10`
- AWS CLI (or any other method to create AWS resources)
- Valid AWS credentials with permissions for S3, DynamoDB, CloudFront, and ACM. Export `AWS_PROFILE`/`AWS_REGION` as needed so the CLI and Terraform use the same account.
- Cloudflare API token with Zone:Read and DNS:Edit scopes for your domain. Export it before running Terraform:
  ```bash
  export CLOUDFLARE_API_TOKEN=your-token
  ```

## One-Time Bootstrap
1. **Create the S3 bucket for state**
   ```bash
   aws s3api create-bucket \
     --bucket <your-tf-state-bucket> \
     --region us-east-1
   aws s3api put-bucket-versioning \
     --bucket <your-tf-state-bucket> \
     --versioning-configuration Status=Enabled
   ```
   If you change the bucket name or region, update the `backend "s3"` block in `terraform.tf`.

2. **Create the DynamoDB table for state locking**
   ```bash
   aws dynamodb create-table \
     --table-name <your-tf-lock-table> \
     --attribute-definitions AttributeName=LockID,AttributeType=S \
     --key-schema AttributeName=LockID,KeyType=HASH \
     --billing-mode PAY_PER_REQUEST \
     --region us-east-1
   ```
   Adjust `terraform.tf` if you pick a different table name or region.

3. **Initialize Terraform**
   ```bash
   terraform -chdir=./infrastructure init
   terraform -chdir=./infrastructure plan
   ```
   Set `TF_VAR_site_bucket_name`, `TF_VAR_project_name`, or `TF_VAR_tags` if you need to override the defaults defined in `variables.tf`.

Once the backend is in place you can run `terraform apply` from the `infrastructure` directory to provision the site resources.

## Cloudflare DNS
The Cloudflare zone for `var.domain_name` must already exist. Terraform will create/maintain the apex and `www` records (CNAMEs pointing at CloudFront) and add the temporary CNAMEs that ACM needs for certificate validation. Remove or import any conflicting records in Cloudflare before applying so Terraform can manage them cleanly.
