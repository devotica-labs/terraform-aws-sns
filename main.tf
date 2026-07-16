# One SNS topic named after the composed label id. Fintech defaults:
# encryption on by default via the AWS-managed alias/aws/sns key (override with a
# CMK through kms_master_key_id). Optional subscriptions and an access policy
# that grants sns:Publish to the listed principals and denies any non-TLS access.
# Default encryption uses the AWS-managed alias/aws/sns key so every topic is
# encrypted with zero setup; callers can pass a CMK via kms_master_key_id.
# trivy:ignore:AVD-AWS-0136 AWS-managed-key encryption is the intended default.
resource "aws_sns_topic" "this" {
  count = local.enabled ? 1 : 0

  name         = local.topic_name
  display_name = local.display_name

  # Server-side encryption. Null/empty leaves the topic unencrypted; the default
  # (alias/aws/sns) keeps every topic encrypted out of the box.
  kms_master_key_id = var.kms_master_key_id

  delivery_policy = var.delivery_policy

  # FIFO ordering. content_based_deduplication only applies to FIFO topics.
  fifo_topic                  = var.fifo_topic
  content_based_deduplication = var.fifo_topic ? var.content_based_deduplication : false

  tags = local.tags
}

resource "aws_sns_topic_subscription" "this" {
  for_each = local.enabled ? var.subscriptions : {}

  topic_arn = aws_sns_topic.this[0].arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
}

resource "aws_sns_topic_policy" "this" {
  count = local.need_policy ? 1 : 0

  arn    = aws_sns_topic.this[0].arn
  policy = data.aws_iam_policy_document.topic[0].json
}
