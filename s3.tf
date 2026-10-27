resource "aws_s3_bucket" "app" {
  count         = var.prevent_destroy ? 0 : 1
  bucket        = local.names.app_bucket
  force_destroy = true
  tags          = merge(local.common_tags, { Name = local.names.app_bucket })
}

resource "aws_s3_bucket" "app_protected" {
  count         = var.prevent_destroy ? 1 : 0
  bucket        = local.names.app_bucket
  force_destroy = false
  tags          = merge(local.common_tags, { Name = local.names.app_bucket })

  lifecycle {
    prevent_destroy = true
  }
}

locals {
  app_bucket_id  = one(concat(aws_s3_bucket.app[*].id, aws_s3_bucket.app_protected[*].id))
  app_bucket_arn = one(concat(aws_s3_bucket.app[*].arn, aws_s3_bucket.app_protected[*].arn))
}

resource "aws_s3_bucket_ownership_controls" "app" {
  bucket = local.app_bucket_id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "app" {
  bucket                  = local.app_bucket_id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app" {
  bucket = local.app_bucket_id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "app" {
  count  = var.enable_versioning ? 1 : 0
  bucket = local.app_bucket_id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "app" {
  count  = var.enable_lifecycle_rule ? 1 : 0
  bucket = local.app_bucket_id

  dynamic "rule" {
    for_each = var.enable_lifecycle_rule ? [1] : []
    content {
      id     = "expire-old-objects"
      status = "Enabled"

      filter {}

      expiration {
        days = var.lifecycle_expiration_days
      }

      dynamic "noncurrent_version_expiration" {
        for_each = var.enable_versioning ? [1] : []
        content {
          noncurrent_days = var.lifecycle_expiration_days
        }
      }
    }
  }

  depends_on = [aws_s3_bucket_versioning.app]
}
