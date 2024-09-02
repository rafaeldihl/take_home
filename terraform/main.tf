resource "aws_secretsmanager_secret" "secrets" {
  for_each    = var.secrets

  name        = each.value.name
  description = each.value.description

  recovery_window_in_days = 0

}

resource "aws_secretsmanager_secret_version" "secrets_version" {
  for_each     = var.secrets
  secret_id    = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value.value
}