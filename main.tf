// ****************************** SNS ****************************** //
module "luna_lottery_recommendation_topic" {
  source            = "./modules/sns_with_kms"
  display_name      = "luna'S Lottery Recommendation SNS"
  sns_name          = "luna_lottery_recommendation_topic"
  tags              = var.tags
  kms_master_key_id = "alias/luna-lottery-system-key-alias"
}

// ****************************** kms ****************************** //
module "lottery_basic_kms" {
  source        = "./modules/kms"
  kms_key_alias = "alias/luna-lottery-system-key-alias"
  tags          = var.tags
}

// ****************************** lambda ****************************** //
module "auto_lottery_generator_lambda" {
  source                  = "./modules/lambda_with_log"
  lambda_function_name    = "luna_auto_lottery_generator_lambda"
  lambda_execute_filename = "./functions/luna_auto_lottery_generator.zip"

  lambda_function_role = module.luna_lottery_recommendation_role.iam_role_arn
  lambda_handler       = "luna_auto_lottery_generator.lottery_generator"
  principal            = "events.amazonaws.com"
  lambda_runtime       = "python3.7"
  source_code_hash     = filebase64sha256("./functions/luna_auto_lottery_generator.zip")
  lambda_env_variables = {
    targetARN = module.luna_lottery_recommendation_topic.aws_sns_topic_arn
  }
  lambda_upstream_source_arn = module.luna_cloudEvent_trigger_lottery_recommendation_lambda.cloudwatch_event_rule_arn
}

// ****************************** SQS ****************************** //
module "luna_lottery_recommendation_queue" {
  source   = "./modules/sqs-with-subscription"
  sqs_name = "luna_lottery_recommendation_SQS"
  subscribed_sns_topic_names = [
  module.luna_lottery_recommendation_topic.aws_sns_topic_arn]
  tags          = var.tags
  filter_policy = jsonencode({ CustomType = ["public"] })
}

// ****************************** cloudEvent ****************************** //
module "luna_cloudEvent_trigger_lottery_recommendation_lambda" {
  source                                = "./modules/cloudevent"
  aws_cloudwatch_event_rule_description = "Luna's Lottery Recommendation, this event will trigger lottery_recommendation_SNS per 5min"
  aws_cloudwatch_event_rule_name        = "luna_cloudEvent_trigger_lottery_recommendation_lambda"
  cloudevent_trigger_target_arn         = module.auto_lottery_generator_lambda.aws_lambda_function_arn
  target_id                             = "SendToSNS"
  event_rule_schedule                   = var.event_rule_schedule
}