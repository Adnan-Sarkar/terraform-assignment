resource "aws_instance" "test" {
  count = local.create_ec2 ? 1 : 0

  ami                    = data.aws_ami.ubuntu[0].id
  instance_type          = local.ec2_instance_type
  vpc_security_group_ids = [aws_security_group.app.id]

  metadata_options {
    http_tokens = "required"
  }

  tags = merge(local.common_tags, { Name = local.names.ec2_test })
}
