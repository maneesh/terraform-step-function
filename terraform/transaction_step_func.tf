resource "aws_sfn_state_machine" "transaction_state_machine" {
  name     = "TransactionStateMachine"
  role_arn = "${aws_iam_role.iam_common_role.arn}"
  definition = <<EOF
  {
  "Comment": "An example of the Amazon States Language for starting a callback task.",
  "StartAt": "Send Message To Queue",
  "States": {
    "Send Message To Queue": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sqs:sendMessage.waitForTaskToken",
      "Parameters": {
        "QueueUrl": "${aws_sqs_queue.transaction_queue.url}",
        "MessageBody": {
          "TransactionType.$": "$.TransactionType",
          "TaskToken.$": "$$.Task.Token"
        }
      },
      "Next": "ValidateTransactionType",
      "Catch": [
      {
        "ErrorEquals": [ "States.ALL" ],
        "Next": "Notify Failure"
      }
      ]
    },
    "Notify Failure": {
      "Type": "Pass",
      "Result": "Callback Task started by Step Functions failed",
      "End": true
    },
    "ValidateTransactionType": {
          "Type" : "Choice",
          "Choices": [ 
            {
              "Variable": "$.TransactionType",
              "StringEquals": "PURCHASE",
              "Next": "Process Purchase"
            },
            {
              "Variable": "$.TransactionType",
              "StringEquals": "REFUND",
              "Next": "Process Refund"
            }
        ]
      },
    "Process Purchase": {
      "Type":"Task",
      "Resource":"arn:aws:states:::lambda:invoke",
      "Parameters":{  
          "FunctionName":"processPurchase"
       },
      "End": true
    },
    "Process Refund": {
      "Type": "Task",
      "Resource":"arn:aws:states:::lambda:invoke",
      "Parameters":{  
          "FunctionName":"processPurchase"
       },
      "Next": "send Refund Notification"
    },
    "send Refund Notification": {
        "Type": "Task",
        "Resource": "arn:aws:states:::sns:publish",
        "Parameters": {
            "TopicArn": "${aws_sns_topic.transaction_refund_update.arn}",
            "Subject": "Refund Initiated",
            "Message": "Your refund is initiated and will be credited to your wallet in next 2-4 working days"
            },
        "End": true
    }
  }
}
EOF
}