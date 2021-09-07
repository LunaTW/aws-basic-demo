variable "sns_name" {
  description = "The name of the SNS topic to create"
  type        = string
}

variable "display_name" {
  description = "The name of the SNS topic to create"
  type        = string
}

variable "tags" {
  description = "A mapping of tags"
  type        = map(string)
}

variable "kms_master_key_id" {}