environment = "staging"
company     = "bjit"
project     = "adnan-tf-assignment"
aws_region  = "ap-southeast-2"

enable_versioning         = true
enable_dynamodb           = true
enable_iam_role           = true
enable_ssm_parameters     = true
enable_cloudwatch_logs    = true
enable_lifecycle_rule     = true
enable_ec2_test_instance  = false
prevent_destroy           = false
lifecycle_expiration_days = 30

ssm_parameters = {
  app_name     = "terraform-training"
  log_level    = "INFO"
  feature_flag = "true"
}

log_groups = {
  app    = 14
  worker = 14
}

allowed_cidr_blocks = ["10.0.0.0/16"]

tags = {
  Owner      = "Adnan"
  CostCenter = "training"
  ManagedBy  = "terraform"
}
