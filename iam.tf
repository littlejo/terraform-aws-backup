data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume_role" {
  count = var.iam_role_enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count              = var.iam_role_enabled ? 1 : 0
  name               = var.iam_role_name
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  #tags                 = 
  permissions_boundary = var.permissions_boundary
}

data "aws_iam_role" "this" {
  count = var.iam_role_enabled ? 0 : var.plan_enabled ? 1 : 0
  name  = var.iam_role_name
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.iam_role_enabled ? 1 : 0
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = join("", aws_iam_role.this.*.name)
}

