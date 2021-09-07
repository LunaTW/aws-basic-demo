module "sqs_with_subscription" {
  source   = "../sqs"
  sqs_name = var.sqs_name
  tags     = var.tags
}

resource "aws_sns_topic_subscription" "lottery_recommendation" {
  count         = length(var.subscribed_sns_topic_names)
  topic_arn     = var.subscribed_sns_topic_names[count.index]
  endpoint      = module.sqs_with_subscription.sqs_queue_arn
  protocol      = "sqs"
  filter_policy = var.filter_policy
}

output "sqs_queue_arn" {
  description = "ARN of sqs topic"
  value       = module.sqs_with_subscription.sqs_queue_arn
}

output "sqs_queue_name" {
  description = "Name of aws_sqs_queue"
  value       = module.sqs_with_subscription.sqs_queue_name
}
