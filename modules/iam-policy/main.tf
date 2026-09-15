resource "aws_iam_policy" "this" {
  name        = var.name
  description = var.description
  policy      = var.policy

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_iam_role_policy_attachment" "this" {
  count = var.role_name != null ? 1 : 0

  role       = var.role_name
  policy_arn = aws_iam_policy.this.arn
}