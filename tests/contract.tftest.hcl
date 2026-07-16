# Contract tests — naming + defaults stay stable across versions.

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
  name      = "contract"
}

run "topic_named_from_label" {
  command = plan
  assert {
    condition     = one([for t in aws_sns_topic.this : t.name]) == "dvtca-test-contract"
    error_message = "Topic name must compose namespace-stage-name."
  }
}

run "kms_default_is_alias_aws_sns" {
  command = plan
  assert {
    condition     = one([for t in aws_sns_topic.this : t.kms_master_key_id]) == "alias/aws/sns"
    error_message = "kms_master_key_id default must stay alias/aws/sns (encryption on by default)."
  }
}
