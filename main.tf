resource "aws_sqs_queue_policy" "sqs_policy_self" {
  count = var.create_dm_subscription == false ? 1 : 0
  queue_url = aws_sqs_queue.terraform_queue[count.index].id

  policy = <<POLICY
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
      "Resource": "${aws_sqs_queue.terraform_queue[count.index].arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.terraform_sns[count.index].arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue_policy" "sqs_policy_dm" {
  count = var.create_dm_subscription == true ? 1 : 0
  queue_url = aws_sqs_queue.terraform_queue[count.index].id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "__dm_policy_ID",
  "Statement": [
    {
      "Sid": "Allow-SendMessage-From-DM",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.terraform_queue[count.index].arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${var.dm_sns}"
        }
      }
    },
    {
      "Sid": "Allow-SendMessage-From-Self",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.terraform_queue[count.index].arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.terraform_sns[count.index].arn}"
        }
      }
    }
  ]
}
POLICY
}

resource "aws_sqs_queue" "terraform_queue_deadletter" {
  name                      = "${var.sqs_name}DLQ"
  receive_wait_time_seconds = var.receive_wait_time_seconds
  message_retention_seconds = var.message_retention_seconds
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
  policy                    = var.sqs_policy

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