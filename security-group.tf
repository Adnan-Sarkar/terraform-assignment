resource "aws_security_group" "app" {
  name        = local.names.app_sg
  description = "Application security group (${var.environment})"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = length(var.allowed_cidr_blocks) > 0 ? local.ingress_ports : []
    content {
      description = "Allow TCP ${ingress.value} from allowed CIDR blocks"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.allowed_cidr_blocks
    }
  }

  tags = merge(local.common_tags, { Name = local.names.app_sg })
}
