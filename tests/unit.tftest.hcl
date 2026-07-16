# Plan-only unit tests — no AWS credentials required. The topic policy resource
# validates its JSON, so mock aws_iam_policy_document to valid JSON.

mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }
}

variables {
  namespace = "dvtca"
  stage     = "test"
  name      = "unit"
}

run "single_topic_by_default" {
  command = plan
  assert {
    condition     = length(aws_sns_topic.this) == 1
    error_message = "Exactly one topic must be planned."
  }
}

run "kms_default_encryption" {
  command = plan
  assert {
    condition     = one([for t in aws_sns_topic.this : t.kms_master_key_id]) == "alias/aws/sns"
    error_message = "kms_master_key_id must default to the AWS-managed alias/aws/sns key."
  }
}

run "no_subscriptions_by_default" {
  command = plan
  assert {
    condition     = length(aws_sns_topic_subscription.this) == 0
    error_message = "No subscriptions unless subscriptions map is supplied."
  }
}

run "one_subscription_per_entry" {
  command = plan
  variables {
    subscriptions = {
      a = { protocol = "sqs", endpoint = "arn:aws:sqs:ap-south-1:111122223333:a" }
      b = { protocol = "https", endpoint = "https://example.com/hook" }
      c = { protocol = "email", endpoint = "ops@example.com" }
    }
  }
  assert {
    condition     = length(aws_sns_topic_subscription.this) == 3
    error_message = "One subscription resource per subscriptions entry."
  }
}

run "no_policy_by_default" {
  command = plan
  assert {
    condition     = length(aws_sns_topic_policy.this) == 0
    error_message = "No topic policy unless policy_principals is supplied."
  }
}

run "policy_when_principals_supplied" {
  command = plan
  variables {
    policy_principals = ["arn:aws:iam::111122223333:role/publisher"]
  }
  assert {
    condition     = length(aws_sns_topic_policy.this) == 1
    error_message = "A topic policy must be attached when policy_principals is supplied."
  }
  assert {
    condition     = length(data.aws_iam_policy_document.topic) == 1
    error_message = "The policy document must render when policy_principals is supplied."
  }
}

run "fifo_topic_name_suffix" {
  command = plan
  variables {
    fifo_topic = true
  }
  assert {
    condition     = one([for t in aws_sns_topic.this : t.name]) == "dvtca-test-unit.fifo"
    error_message = "FIFO topics must carry the .fifo name suffix."
  }
  assert {
    condition     = one([for t in aws_sns_topic.this : t.fifo_topic]) == true
    error_message = "fifo_topic must pass through to the resource."
  }
  assert {
    condition     = one([for t in aws_sns_topic.this : t.content_based_deduplication]) == true
    error_message = "content_based_deduplication must default on for FIFO topics."
  }
}
