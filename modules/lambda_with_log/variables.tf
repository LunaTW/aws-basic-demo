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

variable "lambda_upstream_source_arn" {}

variable "principal" {}