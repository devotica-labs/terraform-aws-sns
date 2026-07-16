output "topic_arn" {
  description = "ARN of the FIFO SNS topic."
  value       = module.sns.topic_arn
}

output "topic_name" {
  description = "Name of the topic (with the .fifo suffix)."
  value       = module.sns.topic_name
}

output "subscription_arns" {
  description = "Subscription key → ARN."
  value       = module.sns.subscription_arns
}
