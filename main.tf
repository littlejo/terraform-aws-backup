locals {
  iam_role_arn = join("", var.iam_role_enabled ? aws_iam_role.this.*.arn : data.aws_iam_role.this.*.arn)
  vault_name   = join("", var.vault_enabled ? aws_backup_vault.this.*.name : data.aws_backup_vault.this.*.name)
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

resource "aws_backup_vault_policy" "this" {
  count = var.vault_policy == "" ? 0 : 1

  backup_vault_name = local.vault_name
  policy            = var.vault_policy
}

resource "aws_backup_plan" "this" {
  count = var.plan_enabled ? 1 : 0
  name  = var.plan_name

  dynamic "rule" {
    for_each = var.rules

    content {
      rule_name                = rule.value.name
      target_vault_name        = local.vault_name
      schedule                 = rule.value.schedule
      start_window             = rule.value.start_window
      completion_window        = rule.value.completion_window
      recovery_point_tags      = rule.value.recovery_point_tags
      enable_continuous_backup = rule.value.enable_continuous_backup

      dynamic "lifecycle" {
        for_each = rule.value.lifecycle != null ? [true] : []

        content {
          cold_storage_after = try(rule.value.lifecycle.cold_storage_after, null)
          delete_after       = try(rule.value.lifecycle.delete_after, null)
        }
      }

      dynamic "copy_action" {
        for_each = try(rule.value.copy_action.destination_vault_arn, null) != null ? [true] : []

        content {
          destination_vault_arn = lookup(rule.value.copy_action, "destination_vault_arn", null)

          dynamic "lifecycle" {
            for_each = try(rule.value.copy_action.lifecycle, null) != null ? [true] : []

            content {
              cold_storage_after = try(rule.value.copy_action.lifecycle.cold_storage_after, null)
              delete_after       = try(rule.value.copy_action.lifecycle.delete_after, null)
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

resource "aws_backup_vault_lock_configuration" "this" {
  count               = var.lock_enabled ? 1 : 0
  backup_vault_name   = local.vault_name
  changeable_for_days = var.lock.changeable_for_days
  max_retention_days  = var.lock.max_retention_days
  min_retention_days  = var.lock.min_retention_days
}

data "aws_iam_role" "this" {
  count = var.iam_role_enabled ? 0 : var.plan_enabled ? 1 : 0
  name  = var.iam_role_name
}

module "iam" {
  source = "./modules/iam"
  count  = var.iam_role_enabled ? 1 : 0

  name                 = var.iam_role_name
  permissions_boundary = var.permissions_boundary
}
