resource "aws_iam_role" "this" {
  name        = var.name
  description = var.description

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = var.trusted_services
        }

        Action = [
          "sts:AssumeRole"
        ]
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
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

resource "aws_iam_policy" "this" {
  count = var.policy != null ? 1 : 0

  name        = var.policy_name != null ? var.policy_name : "${var.name}-policy"
  description = var.policy_description
  policy      = var.policy

  tags = merge(
    var.tags,
    {
      Name = var.policy_name != null ? var.policy_name : "${var.name}-policy"
    }
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.policy != null ? 1 : 0

  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)

  role       = aws_iam_role.this.name
  policy_arn = each.value
}
