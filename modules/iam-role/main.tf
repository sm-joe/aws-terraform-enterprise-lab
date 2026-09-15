data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = var.trusted_services
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

resource "aws_iam_role" "this" {
  name        = var.name
  description = var.description

  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = var.managed_policy_arns

  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0

  name = var.name
  role = aws_iam_role.this.name

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}