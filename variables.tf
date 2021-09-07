variable "tags" {
  description = "A mapping of tags"
  type        = map(string)
  default = {
    system  = "Lottery Suggestion System"
    belong  = "Luna"
    version = "1.0"
    slogan  = "Lottery Recommendation BUY BUY BUY"
  }
}

variable "event_rule_schedule" {
  description = "The schedule in minutes the event rule triggers"
  default     = "rate(5 minutes)"
}