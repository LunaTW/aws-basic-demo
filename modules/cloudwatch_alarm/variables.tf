variable "alarm_name" {}

variable "comparison_operator" {
  description = "the method to compare real value and alarm value"
  default     = "GreaterThanOrEqualToThreshold"
}

variable "evaluation_periods" {
  description = "Datapoints to alarm"
  default     = 1
}

variable "monitoring_period" {
  description = "The number of periods over which data is compared to the specified threshold. ps: trigger it per 5min"
  default     = 300
}

variable "metric_name" {}

variable "namespace" {}

variable "threshold" {
  description = "limited value"
  default     = 1
}

variable "alarm_description" {}

variable "treat_missing_data" {
  description = "Sets how this alarm is to handle missing data points. "
  default     = "notBreaching"
}

variable "statistic" {}

variable "actions_enabled" {
  description = "whether or not actions should be executed during any changes to the alarm's state.  Defaults to true."
  default     = "true"
}

variable "alarm_actions" {
  type = list(string)
}

variable "ok_actions" {
  type = list(string)
}

variable "dimensions" {}