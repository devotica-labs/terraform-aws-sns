output "topic_arn" {
  description = "ARN of the SNS topic (null when the module is disabled)."
  value       = try(aws_sns_topic.this[0].arn, null)
}

output "topic_name" {
  description = "Name of the SNS topic, including the .fifo suffix for FIFO topics (null when the module is disabled)."
  value       = try(aws_sns_topic.this[0].name, null)
}

output "subscription_arns" {
  description = "Map of subscription key → subscription ARN."
  value       = { for k, s in aws_sns_topic_subscription.this : k => s.arn }
}
