resource "aws_secretsmanager_secret" "this" {
  #checkov:skip=CKV_AWS_149:Secrets Manager - Not required for lab environment.
  #checkov:skip=CKV2_AWS_57:Secrets Manager - Not required for lab environment.
  name        = var.name
  description = var.description

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string
}
