
data "archive_file" "process_refund_zip" {
  type        = "zip"
  source_dir= "../ProcessRefund/"
  output_path = "../ProcessRefund.zip"
}

resource "aws_iam_role" "iam_role_process_refund" {
  name               = "iam_role_process_refund"
  assume_role_policy = "${file("iam/lambda_policy.json")}"
}

resource "aws_iam_policy" "pr_policy_dynamodb_lambda" {
  name        = "pr_lambda_dynamodb_access"
  policy = "${file("iam/dynamodb_policy.json")}"
}

// Attach policy to IAM Role to Lambda Function
resource "aws_iam_role_policy_attachment" "iam_policy_pr_ddb" {
  role       = "${aws_iam_role.iam_role_process_refund.name}"
  policy_arn = "${aws_iam_policy.pr_policy_dynamodb_lambda.arn}"
}

resource "aws_lambda_function" "process_refund_lambda" {
  function_name = "processRefund"
  filename         = data.archive_file.process_refund_zip.output_path
  source_code_hash = data.archive_file.process_refund_zip.output_base64sha256
  role    = aws_iam_role.iam_role_process_refund.arn
  handler = "index.handler"
  runtime = "${var.runtimeEnv}"
  timeout = 300
}