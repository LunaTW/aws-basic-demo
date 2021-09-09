resource "aws_cloudwatch_metric_alarm" "default" {
  alarm_name          = var.alarm_name
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  period              = var.monitoring_period
  metric_name         = var.metric_name
  namespace           = var.namespace
  threshold           = var.threshold
  alarm_description   = var.alarm_description
  treat_missing_data  = var.treat_missing_data
  statistic           = var.statistic
  actions_enabled     = var.actions_enabled
  alarm_actions       = var.alarm_actions
  ok_actions          = var.ok_actions
  dimensions          = var.dimensions
}
