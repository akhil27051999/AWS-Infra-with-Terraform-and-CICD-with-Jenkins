data "aws_s3_bucket" "tf_state" {
  bucket = "akhil27051999"
}

# Optional: Only include this if you want Terraform to manage versioning
# Note: This will update versioning config on the existing bucket
resource "aws_s3_bucket_versioning" "tf_state_versioning" {
  bucket = data.aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

