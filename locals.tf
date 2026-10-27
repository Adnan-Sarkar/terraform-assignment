locals {
  env_short = {
    dev     = "dev"
    staging = "stg"
    prod    = "prd"
  }

  region_short = {
    "us-east-1"      = "use1"
    "us-east-2"      = "use2"
    "ap-southeast-2" = "apse2"
  }

  name_prefix = "${var.company}-${var.project}-${local.env_short[var.environment]}"
  region_code = local.region_short[var.aws_region]
  is_prod     = var.environment == "prod"

  names = {
    app_bucket   = "${local.name_prefix}-app-bucket-${local.region_code}"
    config_table = "${local.name_prefix}-config-table-${local.region_code}"
    app_role     = "${local.name_prefix}-app-role-${local.region_code}"
    app_policy   = "${local.name_prefix}-app-policy-${local.region_code}"
    app_sg       = "${local.name_prefix}-app-sg-${local.region_code}"
    ec2_test     = "${local.name_prefix}-test-ec2-${local.region_code}"
  }

  ssm_path_prefix = "/${var.project}/${var.environment}"

  common_tags = merge(
    {
      Company     = var.company
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "terraform"
    },
    var.tags
  )

  ingress_ports = local.is_prod ? [443] : [80, 443]

  create_ec2        = var.enable_ec2_test_instance && var.environment == "dev"
  ec2_instance_type = "t3.micro"
}
