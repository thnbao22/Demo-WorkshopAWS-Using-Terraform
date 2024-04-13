resource "aws_s3_bucket" "s3_bucket" {
  bucket        = "demo-bucket-1"
  # Indicates that all objects in bucket must be emptied before deleting bucket 
  force_destroy = true  
}