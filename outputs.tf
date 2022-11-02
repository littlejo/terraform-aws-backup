output "arn" {
  value = join("", var.vault_enabled ? aws_backup_vault.this.*.arn : data.aws_backup_vault.this.*.arn)
}
