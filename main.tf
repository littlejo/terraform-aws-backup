locals {
  iam_role_arn = join("", var.iam_role_enabled ? aws_iam_role.this.*.arn : data.aws_iam_role.this.*.arn)
}

resource "aws_backup_vault" "this" {
  count       = var.vault_enabled ? 1 : 0
  name        = var.vault_name
  kms_key_arn = var.kms_key_arn
  #tags        = 
}

data "aws_backup_vault" "this" {
  count = var.vault_enabled ? 0 : 1
  name  = var.vault_name
}

resource "aws_backup_plan" "this" {
  count = var.plan_enabled ? 1 : 0
  name  = var.plan_name

  dynamic "rule" {
    for_each = var.rules

    content {
      rule_name                = lookup(rule.value, "name", null)
      target_vault_name        = join("", var.vault_enabled ? aws_backup_vault.this.*.name : data.aws_backup_vault.this.*.name)
      schedule                 = lookup(rule.value, "schedule", null)
      start_window             = lookup(rule.value, "start_window", null)
      completion_window        = lookup(rule.value, "completion_window", null)
      recovery_point_tags      = lookup(rule.value, "recovery_point_tags", null)
      enable_continuous_backup = lookup(rule.value, "enable_continuous_backup", null)

      dynamic "lifecycle" {
        for_each = lookup(rule.value, "lifecycle", null) != null ? [true] : []

        content {
          cold_storage_after = lookup(rule.value.lifecycle, "cold_storage_after", null)
          delete_after       = lookup(rule.value.lifecycle, "delete_after", null)
        }
      }

      dynamic "copy_action" {
        for_each = try(lookup(rule.value.copy_action, "destination_vault_arn", null), null) != null ? [true] : []

        content {
          destination_vault_arn = lookup(rule.value.copy_action, "destination_vault_arn", null)

          dynamic "lifecycle" {
            for_each = lookup(rule.value.copy_action, "lifecycle", null) != null != null ? [true] : []

            content {
              cold_storage_after = lookup(rule.value.copy_action.lifecycle, "cold_storage_after", null)
              delete_after       = lookup(rule.value.copy_action.lifecycle, "delete_after", null)
            }
          }
        }
      }
    }
  }

  #tags = 
}

resource "aws_backup_selection" "this" {
  count         = var.plan_enabled ? 1 : 0
  name          = var.selection_name
  iam_role_arn  = local.iam_role_arn
  plan_id       = join("", aws_backup_plan.this.*.id)
  resources     = var.backup_resources
  not_resources = var.not_resources
  dynamic "selection_tag" {
    for_each = var.selection_tags
    content {
      type  = selection_tag.value["type"]
      key   = selection_tag.value["key"]
      value = selection_tag.value["value"]
    }
  }
}
