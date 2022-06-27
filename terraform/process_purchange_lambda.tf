
data "archive_file" "process_purchase_zip" {
  type        = "zip"
  source_dir= "../ProcessPurchase/"
  output_path = "../ProcessPurchase.zip"
}

resource "aws_iam_role" "iam_role_process_purchase" {
  name               = "iam_role_process_purchase"
  assume_role_policy = "${file("iam/lambda_policy.json")}"
}

resource "aws_iam_policy" "pp_policy_dynamodb_lambda" {
  name        = "pp_lambda_dynamodb_access"
  policy = "${file("iam/dynamodb_policy.json")}"
}

// Attach policy to IAM Role to Lambda Function
resource "aws_iam_role_policy_attachment" "iam_policy_pp_ddb" {
  role       = "${aws_iam_role.iam_role_process_purchase.name}"
  policy_arn = "${aws_iam_policy.pp_policy_dynamodb_lambda.arn}"
}

resource "aws_lambda_function" "process_purchase_lambda" {
  function_name = "processPurchase"
  filename         = data.archive_file.process_purchase_zip.output_path
  source_code_hash = data.archive_file.process_purchase_zip.output_base64sha256
  role    = aws_iam_role.iam_role_process_purchase.arn
  handler = "index.handler"
  runtime = "${var.runtimeEnv}"
}