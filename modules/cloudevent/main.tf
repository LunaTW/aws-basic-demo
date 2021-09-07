#Module      : CLOUDWATCH EVENT
#Description : Terraform module creates Cloudwatch Event on AWS.
resource "aws_cloudwatch_event_rule" "default" {
  name                = var.aws_cloudwatch_event_rule_name
  description         = var.aws_cloudwatch_event_rule_description
  schedule_expression = var.event_rule_schedule
}

#Module      : CLOUDWATCH EVENT TARGET
#Description : Terraform module creates Cloudwatch Event Target on AWS.
resource "aws_cloudwatch_event_target" "default" {
  arn       = var.cloudevent_trigger_target_arn
  rule      = aws_cloudwatch_event_rule.default.name
  target_id = var.target_id
}

output "cloudwatch_event_rule_arn" {
  value   = aws_cloudwatch_event_rule.default.arn
  default = ""
}
