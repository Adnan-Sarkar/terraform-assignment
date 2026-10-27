resource "aws_dynamodb_table" "config" {
  count        = var.enable_dynamodb && !var.prevent_destroy ? 1 : 0
  name         = local.names.config_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = merge(local.common_tags, { Name = local.names.config_table })
}

resource "aws_dynamodb_table" "config_protected" {
  count        = var.enable_dynamodb && var.prevent_destroy ? 1 : 0
  name         = local.names.config_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  point_in_time_recovery {
    enabled = local.is_prod
  }

  tags = merge(local.common_tags, { Name = local.names.config_table })

  lifecycle {
    prevent_destroy = true
  }
}

locals {
  dynamodb_table_name = one(concat(aws_dynamodb_table.config[*].name, aws_dynamodb_table.config_protected[*].name))
  dynamodb_table_arn  = one(concat(aws_dynamodb_table.config[*].arn, aws_dynamodb_table.config_protected[*].arn))
}
