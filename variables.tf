variable "sqs_create" {
  description = "Whether to create SQS queue"
  type        = bool
  default     = true
}

variable "sns_create" {
  description = "Whether to create SNS topic"
  type        = bool
  default     = true
}

variable "sqs_name" {
  description = "Name of the SQS queue"
  type        = string
  default     = ""
}
variable "sns_name" {
  description = "Name of the SNS topic"
  type        = string
  default     = ""
}

variable "delay_seconds" {
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)"
  type        = number
  default     = 0
}
variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = 345600
}
variable "receive_wait_time_seconds" {
  description = "The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)"
  type        = number
  default     = 0

}
variable "sqs_policy" {
  description = "The JSON policy for the SQS queue"
  type        = string
  default     = ""
}

variable "sns_subscriptions" {
  description = "Subscriptions to an SNS topic "
  type        = list(string)
  default     = []
}

variable "sns_filter_policy" {
  description = "JSON object containing attributes that define which messages the subscriber receives"
  type        = string
  default     = ""
}
variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
