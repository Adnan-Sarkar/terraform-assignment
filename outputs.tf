output "environment" {
  value = var.environment
}

output "name_prefix" {
  value = local.name_prefix
}

output "s3_bucket_name" {
  value = local.app_bucket_id
}

output "s3_bucket_arn" {
  value = local.app_bucket_arn
}

output "dynamodb_table_name" {
  value = var.enable_dynamodb ? local.dynamodb_table_name : null
}

output "dynamodb_table_arn" {
  value = var.enable_dynamodb ? local.dynamodb_table_arn : null
}

output "iam_role_name" {
  value = var.enable_iam_role ? aws_iam_role.app[0].name : null
}

output "iam_role_arn" {
  value = var.enable_iam_role ? aws_iam_role.app[0].arn : null
}

output "ssm_parameter_names" {
  value = [for p in aws_ssm_parameter.app : p.name]
}

output "log_group_names" {
  value = { for k, lg in aws_cloudwatch_log_group.app : k => lg.name }
}

output "security_group_id" {
  value = aws_security_group.app.id
}

output "ec2_instance_id" {
  value = local.create_ec2 ? aws_instance.test[0].id : null
}
