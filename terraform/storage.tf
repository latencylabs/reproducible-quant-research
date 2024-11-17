# NOTE: S3 bucket names must be globally unique.
# A random suffix is added to the project name to avoid naming conflicts.
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "data" {
  # S3 bucket names must be globally unique. A random suffix helps avoid conflicts.
  bucket = "${var.project_name}-data-${random_string.bucket_suffix.result}"
  force_destroy = true # Allows deletion of the bucket even if it contains objects

  tags = {
    Name = "${var.project_name}-data-bucket"
  }
}
