# Changelog

All notable changes to this module are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the module
follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Releases are cut automatically by `release-please` on merge to `main`,
driven by Conventional Commit prefixes (`feat:` → minor, `fix:`/`docs:`/`chore:` → patch,
`feat!:`/`BREAKING CHANGE:` → major).

## 0.1.0 (2026-07-16)


### Features

* **ci:** add architecture-diagram workflow + renderer ([ba1375b](https://github.com/devotica-labs/terraform-aws-sns/commit/ba1375b472328f95e5a81e17ca20969aac839eae))
* initial release of terraform-aws-sns ([67eaad2](https://github.com/devotica-labs/terraform-aws-sns/commit/67eaad2cbb702dec92b7d31dcefaea5d5bea6b2b))


### Bug Fixes

* **ci:** drop dead pip/scripts dependabot entry; tflint clean ([689db7a](https://github.com/devotica-labs/terraform-aws-sns/commit/689db7a614c21dc2248bf3b7f6651fdb62da35d1))
* **ci:** pass CI on terraform 1.9.5 ([7da75f6](https://github.com/devotica-labs/terraform-aws-sns/commit/7da75f6be5edb333acd1353825f70c85d1c77bd2))

## [Unreleased]

### Added

- Initial release: an Amazon SNS topic with fintech-safe defaults — server-side
  encryption on by default via the AWS-managed `alias/aws/sns` key (or a CMK) —
  plus optional subscriptions (`aws_sns_topic_subscription` for_each over
  `subscriptions`), an optional access policy (`aws_sns_topic_policy` driven by
  `policy_principals`) that grants `sns:Publish` and denies non-TLS access, and
  FIFO topic support with content-based deduplication. Native `label.tf` naming;
  derived from `cloudposse/terraform-aws-sns-topic`.
