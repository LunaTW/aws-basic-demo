resource "aws_iam_role" "iam_role" {
  name               = var.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.iam_policy_document.json
}

data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.assume_role_identifiers
    }
  }
}

resource "aws_iam_role_policy_attachment" "custom_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.additional_custom_policy.arn
}

resource "aws_iam_policy" "additional_custom_policy" {
  name   = var.additional_custom_policy_name
  policy = var.additional_custom_policy_document_json
}

output "iam_role_arn" {
  description = "ARN of iam role"
  value       = aws_iam_role.iam_role.arn
}
