resource "aws_cloudformation_stack" "sns_email_subscription" {
  name          = var.stack_name
  template_body = data.template_file.cloudformation_sns_email_stack.rendered
  tags          = var.tags
}

data "template_file" "cloudformation_sns_email_stack" {
  template = file("${path.module}/email-sns-stack.json.tpl")
  vars = {
    topicArn = var.topicArn
    protocol = var.protocol
    endpoint = var.email_addresses
  }
}
