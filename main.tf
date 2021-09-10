// ****************************** SNS ****************************** //
module "luna_lottery_recommendation_topic" {
  source            = "./modules/sns_with_kms"
  display_name      = "luna'S Lottery Recommendation SNS"
  sns_name          = "luna_lottery_recommendation_topic"
  tags              = var.tags
  kms_master_key_id = "alias/luna-lottery-system-key-alias"
}

module "luna_monitoring_topic" {
  source       = "./modules/sns"
  display_name = "luna'S monitoring SNS"
  sns_name     = "luna_monitoring_SNS"
  tags         = var.tags
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

module "luna_lottery_SQS_tracking_lambda" {
  source                  = "./modules/lambda_with_log"
  lambda_function_name    = "luna_lottery_SQS_tracking_lambda_for_public_user"
  lambda_execute_filename = "./functions/luna_lottery_SQS_tracking.zip"
  lambda_function_role    = module.luna_lottery_recommendation_sqs_consume_role.iam_role_arn
  lambda_handler          = "luna_lottery_SQS_tracking.sqs_tracking_log"
  principal               = "sqs.amazonaws.com"
  lambda_runtime          = "python3.7"
  source_code_hash        = filebase64sha256("./functions/luna_lottery_SQS_tracking.zip")
  lambda_env_variables = {
    publicUserEmail = var.public_user_email
    sender          = var.admin_email
  }
}

resource "aws_lambda_event_source_mapping" "lottery_SQS_trigger_tracking_lambda" {
  event_source_arn = module.luna_lottery_recommendation_queue.sqs_queue_arn
  function_name    = module.luna_lottery_SQS_tracking_lambda.aws_lambda_function_arn
}

module "luna_vip_lottery_recommendation_monitor_lambda" {
  source                  = "./modules/lambda_with_log_and_dlq"
  lambda_function_name    = "luna_vip_lottery_recommendation_monitor_lambda"
  lambda_execute_filename = "./functions/luna_vip_lottery_recommendation_monitor.zip"
  lambda_function_role    = module.luna_lottery_recommendation_monitoring_role.iam_role_arn
  lambda_handler          = "luna_vip_lottery_recommendation_monitor.vip_lottery_recommendation_monitor"
  principal               = "sns.amazonaws.com"
  source_code_hash        = filebase64sha256("./functions/luna_vip_lottery_recommendation_monitor.zip")
  lambda_runtime          = "python3.7"
  lambda_env_variables = {
    nothing = "nothing"
  }
  tags = var.tags
}

resource "aws_sns_topic_subscription" "lottery_SNS_trigger_tracking_lambda" {
  topic_arn     = module.luna_lottery_recommendation_topic.aws_sns_topic_arn
  protocol      = "lambda"
  endpoint      = module.luna_vip_lottery_recommendation_monitor_lambda.aws_lambda_function_arn
  filter_policy = <<EOF
  {
    "CustomType": ["vip"]
  }
  EOF
}

module "luna_custom_metric_to_cloudwatch_lambda" {
  source                  = "./modules/lambda_with_log"
  lambda_function_name    = "luna_custom_metric_to_cloudwatch_alarm"
  lambda_execute_filename = "./functions/luna_custom_metric_to_cloudwatch.zip"
  lambda_function_role    = module.luna_lottery_recommendation_monitoring_role.iam_role_arn
  lambda_handler          = "luna_custom_metric_to_cloudwatch.custom_metric"
  principal               = "events.amazonaws.com"
  lambda_runtime          = "python3.7"
  source_code_hash        = filebase64sha256("./functions/luna_custom_metric_to_cloudwatch.zip")
  lambda_env_variables = {
    nothing = "nothing"
  }
}

// TODO log filter for what?
//resource "aws_cloudwatch_log_metric_filter" "luna_aws_cloudwatch_log_metric_filter" {
//  name           = "luna_aws_cloudwatch_vip_log_metric_filter"
//  pattern        = "13"
//  log_group_name = module.auto_lottery_generator_lambda.log_group_name
//
//  metric_transformation {
//    name      = "luna_fraud_check_metric"
//    namespace = "Luna"
//    //    dimensions = "fraud_choice"
//    value = "1"
//  }
//}

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


// ****************************** templates ****************************** //
module "luna_lottery_generator_recommendation_email_for_VIP_user" {
  source          = "./modules/sns_email_subscription_with_vip_filter"
  display_name    = "luna_lottery_generator_recommendation_email_for_VIP_user"
  email_addresses = var.vip_user_email
  stack_name      = "lunaSNSSendEmailToVIPUserStack"
  tags            = var.tags
  topicArn        = module.luna_lottery_recommendation_topic.aws_sns_topic_arn
}

module "luna_monitoring_SNS_send_email_to_admin" {
  source          = "./modules/sns_email_subscription"
  display_name    = "luna_monitoring_SNS_send_email_to_admin"
  email_addresses = var.admin_email
  stack_name      = "lunaSNSSendEmailToAdminStack"
  tags            = var.tags
  topicArn        = module.luna_monitoring_topic.aws_sns_topic_arn
}


// ****************************** cloudwatch ******************************//
module "luna_lottery_sqs_message_Visible_alarm" {
  source            = "./modules/cloudwatch_alarm"
  alarm_name        = "luna_lottery_sqs_message_viable_message_alarm"
  alarm_description = "Error: More than 10 lottery recommend number cannot be consumed! "
  dimensions = {
    QueueName = module.luna_lottery_recommendation_queue.dead_letter_queue_name
  }
  metric_name = var.aws_sqs_metric_queue_message_avaiable
  threshold   = 10
  // maximum viable message is 10
  namespace = "AWS/SQS"
  statistic = "Maximum"
  ok_actions = [
  module.luna_monitoring_topic.aws_sns_topic_arn]
  alarm_actions = [
  module.luna_monitoring_topic.aws_sns_topic_arn]
}

module "luna_lottery_fraud_check_alarm_for_vip_user" {
  source            = "./modules/cloudwatch_alarm"
  alarm_name        = "luna_lottery_fraud_check_alarm_for_vip_user"
  alarm_description = "Warning! Warning! Warning! VIP system is under attack!"
  dimensions = {
    QueueName = module.luna_vip_lottery_recommendation_monitor_lambda.dlq_name
  }
  metric_name = var.aws_sqs_metric_queue_message_avaiable
  threshold   = 5
  namespace   = "AWS/SQS"
  statistic   = "Maximum"
  ok_actions = [
  module.luna_monitoring_topic.aws_sns_topic_arn]
  alarm_actions = [
  module.luna_monitoring_topic.aws_sns_topic_arn]
}

// DynamoDB
resource "aws_dynamodb_table" "luna-lottery-dynamodb-table" {
  name           = "luna-lottery-dynamodb-table"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "CustomType"
  range_key      = "RecommendNumber"

  attribute {
    name = "CustomType"
    type = "S"
  }

  attribute {
    name = "RecommendNumber"
    type = "S"
  }

  tags = {
    Name        = "lottery-dynamodb-table"
    Environment = "DEV"
  }
}
