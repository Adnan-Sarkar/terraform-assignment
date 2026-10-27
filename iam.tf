locals {
  iam_statements = merge(
    {
      S3Objects = {
        actions   = ["s3:GetObject", "s3:PutObject"]
        resources = ["${local.app_bucket_arn}/*"]
      }
      S3List = {
        actions   = ["s3:ListBucket"]
        resources = [local.app_bucket_arn]
      }
    },
    var.enable_dynamodb ? {
      DynamoDBTable = {
        actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:Query"]
        resources = [local.dynamodb_table_arn]
      }
    } : {},
    var.enable_ssm_parameters ? {
      SSMRead = {
        actions   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
        resources = ["arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter${local.ssm_path_prefix}/*"]
      }
    } : {},
    var.enable_cloudwatch_logs && length(var.log_groups) > 0 ? {
      LogsWrite = {
        actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
        resources = [for lg in aws_cloudwatch_log_group.app : "${lg.arn}:*"]
      }
    } : {}
  )
}

data "aws_iam_policy_document" "trust" {
  count = var.enable_iam_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "app_access" {
  count = var.enable_iam_role ? 1 : 0

  dynamic "statement" {
    for_each = local.iam_statements
    content {
      sid       = statement.key
      effect    = "Allow"
      actions   = statement.value.actions
      resources = statement.value.resources
    }
  }
}

resource "aws_iam_role" "app" {
  count              = var.enable_iam_role ? 1 : 0
  name               = local.names.app_role
  assume_role_policy = data.aws_iam_policy_document.trust[0].json
  tags               = merge(local.common_tags, { Name = local.names.app_role })
}

resource "aws_iam_policy" "app" {
  count  = var.enable_iam_role ? 1 : 0
  name   = local.names.app_policy
  policy = data.aws_iam_policy_document.app_access[0].json
  tags   = merge(local.common_tags, { Name = local.names.app_policy })
}

resource "aws_iam_role_policy_attachment" "app" {
  count      = var.enable_iam_role ? 1 : 0
  role       = aws_iam_role.app[0].name
  policy_arn = aws_iam_policy.app[0].arn
}
