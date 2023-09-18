output "arn" {
  value = join("", var.vault_enabled ? aws_backup_vault.this.*.arn : data.aws_backup_vault.this.*.arn)
}

output "iam_role_arn" {
  value = local.iam_role_arn
}
