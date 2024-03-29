variable "kms_key_arn" {
  type        = string
  description = "The server-side encryption key that is used to protect your backups"
  default     = null
}

variable "rules" {
  type = list(
    object(
      {
        name                     = optional(string)
        schedule                 = optional(string)
        start_window             = optional(string)
        completion_window        = optional(string)
        recovery_point_tags      = optional(map(string))
        enable_continuous_backup = optional(string)
        lifecycle = optional(object(
          {
            cold_storage_after = optional(number)
            delete_after       = optional(number)
          }
        ))
        copy_action = optional(object(
          {
            destination_vault_arn = optional(string)
            lifecycle = optional(object(
              {
                cold_storage_after = optional(number)
                delete_after       = optional(number)
              }
            ))
          }
        ))
      }
    )
  )
  description = "An array of rule maps used to define schedules in a backup plan"
  default     = []
}

variable "backup_resources" {
  type        = list(string)
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan"
  default     = []
}

variable "not_resources" {
  type        = list(string)
  description = "An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to exclude from a backup plan"
  default     = []
}

variable "vault_policy" {
  type        = string
  description = "Vault policy"
  default     = ""
}

variable "vault_name" {
  type        = string
  description = "Vault Name"
  default     = null
}

variable "vault_enabled" {
  type        = bool
  description = "Should we create a new Vault"
  default     = true
}

variable "plan_name" {
  type        = string
  description = "Backup Plan Name"
  default     = ""
}

variable "plan_enabled" {
  type        = bool
  description = "Should we create a new Plan"
  default     = true
}

variable "selection_name" {
  type        = string
  description = "Backup Resource assignment Name"
  default     = ""
}

variable "selection_tags" {
  type = list(object({
    type  = string
    key   = string
    value = string
  }))
  description = "An array of tag condition objects used to filter resources based on tags for assigning to a backup plan"
  default     = []
}

variable "iam_role_name" {
  type        = string
  description = "You need to create an IAM Role"
  default     = null
}

variable "iam_role_arn" {
  type        = string
  description = "You already created an IAM Role"
  default     = null
}

variable "permissions_boundary" {
  type        = string
  default     = null
  description = "The permissions boundary to set on the role"
}

variable "lock_enabled" {
  type        = bool
  description = "Should we lock backup vault?"
  default     = false
}

variable "lock" {
  type = object({
    changeable_for_days = optional(number)
    max_retention_days  = optional(number)
    min_retention_days  = optional(number)
  })
  description = "Settings of aws vault lock"
  default     = null
}
