
provider "aws" {
    region = "us-east-2"
}

# Create S3 bucket using aws_s3_bucket resource 
resource "aws_s3_bucket" "terraform_state" {
    bucket = "lrofpqx"

    # Prevent accidental deletion  of this S3 bucket
    lifecycle {
        prevent_destroy = true
    }
}

# Enable versioning so you can see the full revision history of your state files
resource "aws_s3_bucket_versioning" "enabled" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
      status = "Enabled"
    }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
    bucket = aws_s3_bucket.terraform_state.id
    
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

# Explicitly block all public access to S3 bucket
resource "aws_s3_bucket_public_access_block" "public_access" {
    bucket  = aws_s3_bucket.terraform_state.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true 
}

#dynamodb for locking
resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-up-and-running-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

resource "aws_s3_bucket" "terraform_state" {

  bucket = var.bucket_name

  # This is only here so we can destroy the bucket as part of automated tests
  # should not copy this for production usage
 
  force_destroy = true

}

