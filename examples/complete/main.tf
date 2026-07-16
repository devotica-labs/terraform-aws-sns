# ---------------------------------------------------------------------------
# Provider block — CI-friendly skip flags + non-AWS-shaped placeholder creds.
# ---------------------------------------------------------------------------
provider "aws" {
  region                      = "ap-south-1"
  access_key                  = "not-a-real-aws-key"
  secret_key                  = "not-a-real-aws-secret"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
}

# A FIFO topic for ordered, deduplicated payment events: encrypted with a
# customer-managed KMS key, fanned out to an email address and an SQS queue, and
# guarded by an access policy that grants publish to a producer role while
# denying any non-TLS access.
module "sns" {
  source = "../.."

  namespace = "dvtca"
  stage     = "prod"
  name      = "payment-events"

  # FIFO ordering with content-based deduplication (topic name → *.fifo).
  fifo_topic                  = true
  content_based_deduplication = true

  # Customer-managed key instead of the AWS-managed alias/aws/sns key.
  kms_master_key_id = "arn:aws:kms:ap-south-1:111122223333:key/00000000-0000-0000-0000-000000000000"

  # Retry/backoff behaviour for HTTP/S delivery.
  delivery_policy = jsonencode({
    http = {
      defaultHealthyRetryPolicy = {
        minDelayTarget     = 20
        maxDelayTarget     = 20
        numRetries         = 3
        numMaxDelayRetries = 0
        numNoDelayRetries  = 0
        numMinDelayRetries = 0
        backoffFunction    = "linear"
      }
      disableSubscriptionOverrides = false
    }
  })

  # Fan-out to an ops mailbox and a downstream SQS queue.
  subscriptions = {
    finance-ops = {
      protocol = "email"
      endpoint = "payments-ops@devotica.com"
    }
    ledger-queue = {
      protocol = "sqs"
      endpoint = "arn:aws:sqs:ap-south-1:111122223333:ledger-events.fifo"
    }
  }

  # Only the payments API role may publish; everything must be over TLS.
  policy_principals = ["arn:aws:iam::111122223333:role/payments-api"]

  tags = {
    Environment = "prod"
    Project     = "terraform-aws-sns"
    Owner       = "platform@devotica.com"
    CostCenter  = "PLATFORM-OSS"
    ManagedBy   = "Terraform"
    Repo        = "https://github.com/devotica-labs/terraform-aws-sns"
  }
}
