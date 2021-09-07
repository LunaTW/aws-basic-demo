variable "sqs_name" {
  description = "The name of the SQS to create"
  type        = string
}

variable "tags" {
  description = "A mapping of tags"
  type        = map(string)
}

variable "subscribed_sns_topic_names" {
  description = "This sns with be subscribed"
  type        = list(string)
}

variable "filter_policy" {}

