resource "aws_sqs_queue" "terraform_queue_deadletter" {
  name                      = "${var.sqs_name}DLQ"
  receive_wait_time_seconds = var.receive_wait_time_seconds
  message_retention_seconds = var.message_retention_seconds

  tags                      = local.tags
}

resource "aws_sqs_queue" "terraform_queue" {
  count = var.sqs_create ? 1 : 0

  name                      = var.sqs_name
  delay_seconds             = var.delay_seconds
  max_message_size          = var.max_message_size
  message_retention_seconds = var.message_retention_seconds
  receive_wait_time_seconds = var.receive_wait_time_seconds
  redrive_policy            = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 5
  })
  policy                    = var.sqs_policy == "" ? local.default_sqs_policy : var.sqs_policy

  tags                      = local.tags
}

resource "aws_sns_topic" "terraform_sns" {
  count = var.sns_create ? 1 : 0

  name = var.sns_name
  tags = local.tags
}

resource "aws_sns_topic_subscription" "terraform_sns_subscription" {
for_each = toset(var.sns_subscriptions)
  topic_arn            = aws_sns_topic.terraform_sns[0].arn
  protocol             = "sqs"
  endpoint             = "arn:aws:sqs:eu-west-1:${local.account_id}:${each.key}"
  raw_message_delivery = true
  filter_policy        = var.sns_filter_policy
}