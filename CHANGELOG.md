# Changelog

All notable changes to this module are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the module
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Releases are cut automatically by `release-please` on merge to `main`,
driven by Conventional Commit prefixes (`feat:` → minor, `fix:`/`docs:`/`chore:` → patch,
`feat!:`/`BREAKING CHANGE:` → major).

## [Unreleased]

### Added

- Initial release: an Amazon SNS topic with fintech-safe defaults — server-side
  encryption on by default via the AWS-managed `alias/aws/sns` key (or a CMK) —
  plus optional subscriptions (`aws_sns_topic_subscription` for_each over
  `subscriptions`), an optional access policy (`aws_sns_topic_policy` driven by
  `policy_principals`) that grants `sns:Publish` and denies non-TLS access, and
  FIFO topic support with content-based deduplication. Native `label.tf` naming;
  derived from `cloudposse/terraform-aws-sns-topic`.
