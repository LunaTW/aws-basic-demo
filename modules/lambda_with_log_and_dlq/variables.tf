variable "lambda_execute_filename" {
  description = "lambda filename under aws_lambda_function"
}

variable "lambda_function_name" {}

variable "lambda_function_role" {
  description = "who is going to execute the program in lambda"
}

variable "lambda_handler" {}

variable "lambda_runtime" {}

variable "source_code_hash" {}

variable "lambda_env_variables" {
  description = "this is the env variable prepared for lambda"
  //  type    = map(string)
  default = null
}

variable "lambda_upstream_source_arn" {
  default = ""
}

variable "principal" {}

variable "tags" {
  description = "A mapping of tags"
  type        = map(string)
}

variable "dead_letter_queue_message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message."
  default     = 604800
}