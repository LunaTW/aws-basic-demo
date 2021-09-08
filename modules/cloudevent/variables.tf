variable "aws_cloudwatch_event_rule_name" {}

variable "aws_cloudwatch_event_rule_description" {}

variable "event_rule_schedule" {
  description = "The schedule in minutes the event rule triggers"
}

variable "target_id" {}

variable "cloudevent_trigger_target_arn" {
  default = ""
}
