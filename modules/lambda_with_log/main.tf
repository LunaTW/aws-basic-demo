resource "aws_lambda_function" "lambda" {
  filename         = var.lambda_execute_filename
  function_name    = var.lambda_function_name
  role             = var.lambda_function_role
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  source_code_hash = var.source_code_hash
  depends_on       = [aws_cloudwatch_log_group.example]
  environment {
    variables = var.lambda_env_variables
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = var.principal
  source_arn    = var.lambda_upstream_source_arn
}

# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.lambda_function_name}"
  retention_in_days = 14
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.example.name
}

output "log_group_arn" {
  value = aws_cloudwatch_log_group.example.arn
}

output "aws_lambda_function_arn" {
  value = aws_lambda_function.lambda.arn
}