
#===============================================================
data "archive_file" "process_purchase_zip" {
  type        = "zip"
  source_dir= "../ProcessPurchase/"
  output_path = "../ProcessPurchase.zip"
}

resource "aws_lambda_function" "process_purchase_lambda" {
  function_name = "processPurchase"
  filename         = data.archive_file.process_purchase_zip.output_path
  source_code_hash = data.archive_file.process_purchase_zip.output_base64sha256
  role    = "${aws_iam_role.iam_common_role.arn}"
  handler = "index.handler"
  runtime = "${var.runtimeEnv}"
  timeout = 60
}
#===============================================================


data "archive_file" "process_refund_zip" {
  type        = "zip"
  source_dir= "../ProcessRefund/"
  output_path = "../ProcessRefund.zip"
}

resource "aws_lambda_function" "process_refund_lambda" {
  function_name = "processRefund"
  filename         = data.archive_file.process_refund_zip.output_path
  source_code_hash = data.archive_file.process_refund_zip.output_base64sha256
  role    = "${aws_iam_role.iam_common_role.arn}"
  handler = "index.handler"
  runtime = "${var.runtimeEnv}"
  timeout = 60
}


#===============================================================

data "archive_file" "input_validator_zip" {
  type        = "zip"
  source_file= "../ValidatorLambda/index.js"
  output_path = "../ValidatorLambda.zip"
}

resource "aws_lambda_function" "validator_lambda" {
  function_name = "validatorLambda"
  filename         = data.archive_file.input_validator_zip.output_path
  source_code_hash = data.archive_file.input_validator_zip.output_base64sha256
  role    = "${aws_iam_role.iam_common_role.arn}"
  handler = "index.handler"
  runtime = "${var.runtimeEnv}"
  timeout = 30
}

#===============================================================