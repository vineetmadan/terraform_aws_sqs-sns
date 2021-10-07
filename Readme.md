# AWS SQS-SNS Terraform Module

## Overview

This module is designed to create _AWS SQS &/or SNS_ in a simple and repeatable way.  

- _SQS & SNS_
- _SQS Policy_
- _SNS Subscriptions_

---

## Usage

A standard use of the module from a _Terraform_ working directory.

```
module "sqs-sns" {
  source = "../modules/sqs-sns"
  
  sqs_name  =  "CompanyDev"
  sns_name  =  "CompanyDev"

  create_dm_subscription  =  true

  sns_subscriptions  =  ["CompanyDev", "UnisearchDev"]

  tags  =  {
    "Environment" = infra,
    "Terraform"   = "True"
  }
}

```

---

## Requirements

This module requires the following versions to be configured in the workspace `terraform {}` block.

### Terraform

| **Version** |
| :---------- |
| `>= 1.0.7` |

### Providers

| **Name**                                                            | **Version** |
| :------------------------------------------------------------------ | :---------- |
| [AWS](https://registry.terraform.io/providers/hashicorp/aws/latest) | `>= 3.61.0`  |

---

## Variables

| **Variable**      | **Description**                                                     | **Type**       | **Default** |
| :---------------- | :------------------------------------------------------------------ | :------------- | :---------- |
| `sqs_create`            | Whether to create SQS queue                                           | `boolean`       | `true`       |
| `sns_create`     | Whether to create SNS topic                                    | `boolean`       | `true`        |
| `sqs_name`    | Name of the SQS queue                                    | `string`         | `""`      |
| `sns_name`          | Name of the SNS topic                                | `string`       | `""`       |
| `create_dm_subscription`            | Whether to create DM Subscription                                              | `boolean`  | `false`        |
| `delay_seconds`       | The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)             | `number` | `0`       |
| `max_message_size`       | The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB) | `number`       | `262144`       |
| `message_retention_seconds` | The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)      | `number`       | `345600`       |
| `receive_wait_time_seconds`            | The time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds)                                              | `number`  | `0`        |
| `sqs_policy`            | The JSON policy for the SQS queue                                              | `string`  | `nil`        |
| `sns_subscriptions`            | Subscriptions to an SNS topic                                              | `list(string)`  | `[]`        |
| `sns_filter_policy`            | JSON object containing attributes that define which messages the subscriber receives                                              | `string`  | `""`        |
| `tags`            | Tags to apply to role.                                              | `map(string)`  | `{}`        |


---

## Outputs

| **Variable** | **Description**                                     | **Type** |
| :----------- | :-------------------------------------------------- | :------- |
| `sqs_arn`         | The ARN of the SQS queue                               | `string` |
| `sns_arn`       | The ARN of the SNS topic                               | `string` |