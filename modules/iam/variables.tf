variable "name" {
  description = "Name of iam role"
  type        = string
  default     = "backup"
}

variable "permissions_boundary" {
  description = "Permissions boundary of iam role"
  type        = string
  default     = null
}
