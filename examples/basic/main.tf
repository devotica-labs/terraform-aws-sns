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

# Uses local path during development.
# Change to Registry source after first release:
#   source  = "devotica-labs/sns/aws"
#   version = "~> 0.1"

module "sns" {
  source = "../.."

  # Topic name composes to: dvtca-sandbox-alerts
  namespace = "dvtca"
  stage     = "sandbox"
  name      = "alerts"

  # Fintech default covers encryption: the AWS-managed alias/aws/sns key.

  # A single HTTPS subscription (endpoint is confirmed out of band by SNS).
  subscriptions = {
    ops = {
      protocol = "https"
      endpoint = "https://ops.example.com/sns/webhook"
    }
  }

  tags = {
    Environment = "sandbox"
    Project     = "terraform-aws-sns"
    Owner       = "platform@devotica.com"
    CostCenter  = "PLATFORM-OSS"
    ManagedBy   = "Terraform"
    Repo        = "https://github.com/devotica-labs/terraform-aws-sns"
  }
}
