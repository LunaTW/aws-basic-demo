variable "sqs_name" {
  description = "The name of the SQS to create"
  type        = string
}

variable "tags" {
  description = "A mapping of tags"
  type        = map(string)
}

variable "sqs_message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message."
  default     = 604800
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue."
  default     = 300
}

variable "dead_letter_maxReceive_Count" {
  default = 5
}

variable "dead_letter_queue_message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message."
  default     = 604800
}
