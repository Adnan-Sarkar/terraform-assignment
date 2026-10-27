environment = "prod"
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
prevent_destroy           = true
lifecycle_expiration_days = 90

ssm_parameters = {
  app_name     = "terraform-training"
  log_level    = "WARN"
  feature_flag = "false"
}

log_groups = {
  app    = 30
  worker = 30
}

allowed_cidr_blocks = ["10.0.0.0/24"]

tags = {
  Owner       = "Adnan"
  CostCenter  = "training"
  ManagedBy   = "terraform"
  Environment = "prod"
  DataClass   = "internal"
}
