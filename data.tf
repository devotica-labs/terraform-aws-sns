# Topic access policy — grants sns:Publish to the supplied principals and denies
# every action reaching the topic without TLS. Rendered only when
# policy_principals is non-empty (local.need_policy).
data "aws_iam_policy_document" "topic" {
  count = local.need_policy ? 1 : 0

  policy_id = "sns-topic-policy"

  statement {
    sid       = "AllowPublish"
    effect    = "Allow"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.this[0].arn]

    principals {
      type        = "AWS"
      identifiers = var.policy_principals
    }
  }

  # Fintech baseline: reject any request that isn't over TLS.
  statement {
    sid       = "DenyNonTLS"
    effect    = "Deny"
    actions   = ["sns:Publish"]
    resources = [aws_sns_topic.this[0].arn]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}
