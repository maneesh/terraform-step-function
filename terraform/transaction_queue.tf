resource "aws_sqs_queue" "transaction_queue" {
  name                      = "transaction_queue"
  delay_seconds             = 0
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 1
  policy = "${file("iam/common_role_policy.json")}"
}

resource "aws_lambda_event_source_mapping" "validation_lambda_mapping" {
  event_source_arn = aws_sqs_queue.transaction_queue.arn
  function_name    = aws_lambda_function.validator_lambda.arn
}