locals {

  default_sqs_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "__policy_ID",
  "Statement": [
    {
      "Sid": "Allow-SendMessage-From-Self",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:eu-west-1:${local.account_id}:${var.sqs_name}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "arn:aws:sns:eu-west-1:${local.account_id}:${var.sns_name}"
        }
      }
    }
  ]
}
POLICY
  account_id = data.aws_caller_identity.current.account_id

  tags = merge(var.tags, { Terraform = "true" })
}