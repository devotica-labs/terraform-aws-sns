locals {
  # FIFO topics must carry the .fifo suffix; standard topics use the bare id.
  topic_name = var.fifo_topic ? "${local.id}.fifo" : local.id

  # Display names can't contain dots, so strip the .fifo suffix for the label.
  display_name = replace(local.id, ".", "-")

  # A topic access policy is rendered only when publish principals are supplied.
  need_policy = local.enabled && length(var.policy_principals) > 0
}
