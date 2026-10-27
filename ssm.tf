resource "aws_ssm_parameter" "app" {
  for_each = var.enable_ssm_parameters ? var.ssm_parameters : {}

  name  = "${local.ssm_path_prefix}/${each.key}"
  type  = "String"
  value = each.value
  tier  = "Standard"
  tags  = local.common_tags
}
