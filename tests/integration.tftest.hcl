# Integration tests — apply + assert + destroy. Requires real AWS credentials.
# A single empty topic is cheap and fast to create/destroy.

provider "aws" {
  region = "ap-south-1"
}

variables {
  namespace = "dvtca"
  stage     = "integ"
  name      = "sns"

  tags = {
    Environment = "integration-test"
    Ephemeral   = "true"
  }
}

run "apply_and_assert" {
  command = apply

  assert {
    condition     = one([for t in aws_sns_topic.this : t.arn]) != ""
    error_message = "Topic must be created with an ARN."
  }
  assert {
    condition     = one([for t in aws_sns_topic.this : t.kms_master_key_id]) == "alias/aws/sns"
    error_message = "Topic must be encrypted with the default alias/aws/sns key."
  }
}
