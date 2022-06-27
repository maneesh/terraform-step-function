resource "aws_iam_role" "iam_role_transaction_step_function" {
  name               = "iam_role_step_function"
  assume_role_policy = "${file("iam/step_function_policy.json")}"
}


resource "aws_iam_policy" "policy_invoke_lambda" {
  name        = "transactionStepFuncInvokeLambda"
  policy = "${file("iam/invoke_lambda.json")}"
}

// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = "${aws_iam_role.iam_role_transaction_step_function.name}"
  policy_arn = "${aws_iam_policy.policy_invoke_lambda.arn}"
}

resource "aws_sfn_state_machine" "transaction_state_machine" {
  name     = "TransactionStateMachine"
  role_arn = aws_iam_role.iam_role_transaction_step_function.arn
  definition = <<EOF
  {
    "Comment": "A simple AWS Step Functions state machine that automates a call center support session.",
    "StartAt": "ProcessTransaction",
    "States": {
      "ProcessTransaction": {
          "Type" : "Choice",
          "Choices": [ 
            {
              "Variable": "$.TransactionType",
              "StringEquals": "PURCHASE",
              "Next": "ProcessPurchase"
            },
            {
              "Variable": "$.TransactionType",
              "StringEquals": "REFUND",
              "Next": "ProcessRefund"
            }
        ]
      },
       "ProcessRefund": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.process_refund_lambda.arn}",
        "End": true
      },
      "ProcessPurchase": {
        "Type": "Task",
        "Resource": "${aws_lambda_function.process_purchase_lambda.arn}",
        "End": true
      }
    }
  }
  EOF
}