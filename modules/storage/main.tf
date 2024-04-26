resource "aws_s3_bucket" "s3_bucket" {
  # If omitted, Terraform will assign a random, unique name. 
  # bucket        = "demo-bucket-1"
  # Indicates that all objects in bucket must be emptied before deleting bucket 
  force_destroy = true  
}
# Provides a resource to manage S3 Bucket Ownership Controls.
resource "aws_s3_bucket_ownership_controls" "object_ownership" {
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
# Manages S3 bucket-level Public Access Block configuration.
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.s3_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
# Provides an S3 bucket ACL resource.
resource "aws_s3_bucket_acl" "recommended" {
  depends_on  = [ aws_s3_bucket_ownership_controls.object_ownership ]
  bucket      = aws_s3_bucket.s3_bucket.id
  acl         = "private"
}
# Provides a resource for controlling versioning on an S3 bucket. 
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket    = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status  = "Disabled"
  }
}