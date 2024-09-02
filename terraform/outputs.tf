output "secret_arns" {
  description = "The ARNs of the created secrets."
  value       = { for k, v in aws_secretsmanager_secret.secrets : k => v.arn }
}

output "secret_ids" {
  description = "The IDs of the created secrets."
  value       = { for k, v in aws_secretsmanager_secret.secrets : k => v.id }
}
