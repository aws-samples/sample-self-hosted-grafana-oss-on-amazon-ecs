resource "aws_secretsmanager_secret" "grafana_admin_password" {
  name        = "grafana-oss-admin-password"
  description = "Grafana admin password"
  recovery_window_in_days = 7
  tags = var.tags
}

resource "aws_secretsmanager_secret_version" "grafana_admin_password" {
  secret_id     = aws_secretsmanager_secret.grafana_admin_password.id
  secret_string = var.grafana_admin_password
}

# Grant ECS task execution role permission to read the secret
resource "aws_iam_policy" "secrets_access_policy" {
  name        = "${var.project_name}-secrets-access-policy"
  description = "Policy to allow access to Secrets Manager secrets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = [
          aws_secretsmanager_secret.grafana_admin_password.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_policy_attachment" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = aws_iam_policy.secrets_access_policy.arn
}