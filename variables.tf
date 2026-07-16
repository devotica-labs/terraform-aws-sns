# ---------------------------------------------------------------------------
# Topic
# ---------------------------------------------------------------------------
variable "fifo_topic" {
  type        = bool
  description = "Create a FIFO (first-in-first-out) topic. The topic name gets the required .fifo suffix and content-based deduplication is enabled by default."
  default     = false
}

variable "content_based_deduplication" {
  type        = bool
  description = "Enable content-based deduplication. Applies only to FIFO topics (ignored when fifo_topic = false)."
  default     = true
}

variable "delivery_policy" {
  type        = string
  description = "The SNS delivery policy as JSON (retry/throttle behaviour for HTTP/S subscriptions). Null uses the SNS defaults."
  default     = null
}

# ---------------------------------------------------------------------------
# Encryption
# ---------------------------------------------------------------------------
variable "kms_master_key_id" {
  type        = string
  description = "KMS key id/alias/ARN for server-side encryption. Defaults to the AWS-managed alias/aws/sns key so topics are encrypted out of the box; supply a CMK id/ARN for a customer-managed key, or null to disable encryption."
  default     = "alias/aws/sns"
}

# ---------------------------------------------------------------------------
# Subscriptions
# ---------------------------------------------------------------------------
variable "subscriptions" {
  type = map(object({
    protocol = string
    endpoint = string
  }))
  description = "Map of subscription key → { protocol, endpoint }. Protocol is one of sqs, lambda, sms, application, https, email, email-json, firehose. The endpoint shape depends on the protocol (e.g. an ARN for sqs/lambda, a URL for https, an address for email)."
  default     = {}
}

# ---------------------------------------------------------------------------
# Access policy
# ---------------------------------------------------------------------------
variable "policy_principals" {
  type        = list(string)
  description = "IAM principal ARNs granted sns:Publish via the topic policy. When non-empty a policy is attached that grants publish to these principals and denies all non-TLS (aws:SecureTransport = false) access. Empty (default) attaches no policy."
  default     = []
}
