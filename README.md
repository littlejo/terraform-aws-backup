<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.37.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_backup_plan.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_plan) | resource |
| [aws_backup_selection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_selection) | resource |
| [aws_backup_vault.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault) | resource |
| [aws_backup_vault_lock_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_lock_configuration) | resource |
| [aws_backup_vault_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/backup_vault_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_backup_vault.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/backup_vault) | data source |
| [aws_iam_policy_document.assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_resources"></a> [backup\_resources](#input\_backup\_resources) | An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to assign to a backup plan | `list(string)` | `[]` | no |
| <a name="input_iam_role_enabled"></a> [iam\_role\_enabled](#input\_iam\_role\_enabled) | Should we create a new Iam Role and Policy Attachment | `bool` | `true` | no |
| <a name="input_iam_role_name"></a> [iam\_role\_name](#input\_iam\_role\_name) | Override target IAM Role Name | `string` | `null` | no |
| <a name="input_kms_key_arn"></a> [kms\_key\_arn](#input\_kms\_key\_arn) | The server-side encryption key that is used to protect your backups | `string` | `null` | no |
| <a name="input_lock"></a> [lock](#input\_lock) | Settings of aws vault lock | <pre>object({<br>    changeable_for_days = optional(number)<br>    max_retention_days  = optional(number)<br>    min_retention_days  = optional(number)<br>  })</pre> | `null` | no |
| <a name="input_lock_enabled"></a> [lock\_enabled](#input\_lock\_enabled) | Should we lock backup vault? | `bool` | `false` | no |
| <a name="input_not_resources"></a> [not\_resources](#input\_not\_resources) | An array of strings that either contain Amazon Resource Names (ARNs) or match patterns of resources to exclude from a backup plan | `list(string)` | `[]` | no |
| <a name="input_permissions_boundary"></a> [permissions\_boundary](#input\_permissions\_boundary) | The permissions boundary to set on the role | `string` | `null` | no |
| <a name="input_plan_enabled"></a> [plan\_enabled](#input\_plan\_enabled) | Should we create a new Plan | `bool` | `true` | no |
| <a name="input_plan_name"></a> [plan\_name](#input\_plan\_name) | Backup Plan Name | `string` | `""` | no |
| <a name="input_rules"></a> [rules](#input\_rules) | An array of rule maps used to define schedules in a backup plan | <pre>list(<br>    object(<br>      {<br>        name                     = optional(string)<br>        schedule                 = optional(string)<br>        start_window             = optional(string)<br>        completion_window        = optional(string)<br>        recovery_point_tags      = optional(map(string))<br>        enable_continuous_backup = optional(string)<br>        lifecycle = optional(object(<br>          {<br>            cold_storage_after = optional(number)<br>            delete_after       = optional(number)<br>          }<br>        ))<br>        copy_action = optional(object(<br>          {<br>            destination_vault_arn = optional(string)<br>            lifecycle = optional(object(<br>              {<br>                cold_storage_after = optional(number)<br>                delete_after       = optional(number)<br>              }<br>            ))<br>          }<br>        ))<br>      }<br>    )<br>  )</pre> | `[]` | no |
| <a name="input_selection_name"></a> [selection\_name](#input\_selection\_name) | Backup Resource assignment Name | `string` | `""` | no |
| <a name="input_selection_tags"></a> [selection\_tags](#input\_selection\_tags) | An array of tag condition objects used to filter resources based on tags for assigning to a backup plan | <pre>list(object({<br>    type  = string<br>    key   = string<br>    value = string<br>  }))</pre> | `[]` | no |
| <a name="input_vault_enabled"></a> [vault\_enabled](#input\_vault\_enabled) | Should we create a new Vault | `bool` | `true` | no |
| <a name="input_vault_name"></a> [vault\_name](#input\_vault\_name) | Vault Name | `string` | n/a | yes |
| <a name="input_vault_policy"></a> [vault\_policy](#input\_vault\_policy) | Vault policy | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
<!-- END_TF_DOCS -->
