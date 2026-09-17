resource "aws_instance" "this" {
  #checkov:skip=CKV_AWS_126:EC2 - Not required for lab environment.
  #checkov:skip=CKV_AWS_133:EC2 - Not required for lab environment.

  ami                         = var.ami_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  user_data                   = var.user_data_file != null ? file(var.user_data_file) : null
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip_address
  source_dest_check           = var.source_dest_check
  ebs_optimized               = var.ebs_optimized

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    volume_type           = var.root_volume_type
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_eip" "this" {
  count = var.associate_elastic_ip ? 1 : 0

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-eip"
    }
  )
}

resource "aws_eip_association" "this" {
  count = var.associate_elastic_ip ? 1 : 0

  instance_id   = aws_instance.this.id
  allocation_id = aws_eip.this[0].id
}
