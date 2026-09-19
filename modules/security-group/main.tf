resource "aws_security_group" "this" {
  #checkov:skip=CKV2_AWS_5:Security Group - Not required for lab environment.
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "this" {
  for_each = {
    for index, rule in var.ingress_rules :
    index => rule
  }

  security_group_id = aws_security_group.this.id

  description = each.value.description
  from_port   = each.value.protocol == "-1" ? null : each.value.from_port
  to_port     = each.value.protocol == "-1" ? null : each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv4 = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks[0] : null

  referenced_security_group_id = each.value.source_security_group_id
}

# trivy:ignore:AVD-AWS-0104
resource "aws_vpc_security_group_egress_rule" "this" {
  for_each = {
    for index, rule in var.egress_rules :
    index => rule
  }

  security_group_id = aws_security_group.this.id

  description = each.value.description
  from_port   = each.value.protocol == "-1" ? null : each.value.from_port
  to_port     = each.value.protocol == "-1" ? null : each.value.to_port
  ip_protocol = each.value.protocol

  cidr_ipv4 = length(each.value.cidr_blocks) > 0 ? each.value.cidr_blocks[0] : null
}
