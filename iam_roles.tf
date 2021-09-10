module "luna_lottery_recommendation_role" {
  source                                 = "./modules/iam"
  iam_role_name                          = "luna_lottery_recommendation_role"
  assume_role_identifiers                = ["lambda.amazonaws.com"]
  additional_custom_policy_name          = "luna_lottery_custom_policy_2"
  additional_custom_policy_document_json = data.aws_iam_policy_document.luna_lottery_custom_policy_document.json
}

data "aws_iam_policy_document" "luna_lottery_custom_policy_document" {
  statement {
    actions = ["logs:CreateLogGroup",
      "logs:CreateLogStream",
    "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
    ]
    resources = ["*"]
  }
}

module "luna_lottery_recommendation_sqs_consume_role" {
  source                                 = "./modules/iam"
  iam_role_name                          = "luna_lottery_recommendation_sqs_consume_role"
  assume_role_identifiers                = ["lambda.amazonaws.com"]
  additional_custom_policy_name          = "luna_lottery_recommendation_sqs_consume_role_policy_2"
  additional_custom_policy_document_json = data.aws_iam_policy_document.luna_lottery_recommendation_sqs_consume_policy_document.json
}

data "aws_iam_policy_document" "luna_lottery_recommendation_sqs_consume_policy_document" {
  statement {
    actions = ["logs:CreateLogGroup",
      "logs:CreateLogStream",
    "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions   = ["sqs:*"]
    resources = ["arn:aws:sqs:*:*:*"]
  }

  statement {
    actions = ["ses:SendEmail",
    "ses:SendRawEmail"]
    resources = ["*"]
  }
}

module "luna_lottery_recommendation_monitoring_role" {
  source                                 = "./modules/iam"
  iam_role_name                          = "luna_lottery_recommendation_monitoring_role"
  assume_role_identifiers                = ["lambda.amazonaws.com"]
  additional_custom_policy_name          = "luna_lottery_recommendation_monitoring_role_policy_2"
  additional_custom_policy_document_json = data.aws_iam_policy_document.luna_lottery_recommendation_monitoring_role_policy_document.json
}

data "aws_iam_policy_document" "luna_lottery_recommendation_monitoring_role_policy_document" {
  statement {
    actions = ["logs:CreateLogGroup",
      "logs:CreateLogStream",
    "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions   = ["sns:*"]
    resources = ["arn:aws:sns:*:*:*"]
  }

  statement {
    actions   = ["sqs:*"]
    resources = ["arn:aws:sqs:*:*:*"]
  }

  statement {
    actions   = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }

}
