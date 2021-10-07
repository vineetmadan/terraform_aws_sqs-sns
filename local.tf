locals {
  account_id = data.aws_caller_identity.current.account_id

  tags = merge(var.tags, { Terraform = "true" })
}