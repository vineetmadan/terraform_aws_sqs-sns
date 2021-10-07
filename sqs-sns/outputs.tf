output "sqs_arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.terraform_queue.*.arn
}

output "sns_arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic.terraform_sns.*.arn
}

