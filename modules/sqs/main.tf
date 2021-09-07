resource "aws_sqs_queue" "sqs" {
  name                       = var.sqs_name
  tags                       = var.tags
  message_retention_seconds  = var.sqs_message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead-letter-queue.arn
    maxReceiveCount     = var.dead_letter_maxReceive_Count
  })
}

resource "aws_sqs_queue" "dead-letter-queue" {
  name                      = "${var.sqs_name}-dead-letter-queue"
  message_retention_seconds = var.dead_letter_queue_message_retention_seconds
  tags                      = var.tags
}

resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.sqs.id
  policy    = data.aws_iam_policy_document.queue_policy_document.json
}

data "aws_iam_policy_document" "queue_policy_document" {
  policy_id = "__default_policy_ID"

  statement {
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage"
    ]

    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      aws_sqs_queue.sqs.arn,
    ]

    sid = "__default_statement_ID"
  }
}

output "sqs_queue_arn" {
  description = "ARN of sqs topic"
  value       = aws_sqs_queue.sqs.arn
}

output "sqs_queue_name" {
  description = "Name of aws_sqs_queue"
  value       = aws_sqs_queue.sqs.name
}

output "dead_letter_queue_arn" {
  description = "ARN of dlq topic"
  value       = aws_sqs_queue.dead-letter-queue.arn
}

output "dead_letter_queue_name" {
  description = "Name of dlq"
  value       = aws_sqs_queue.dead-letter-queue.name
}
