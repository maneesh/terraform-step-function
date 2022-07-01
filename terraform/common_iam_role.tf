resource "aws_iam_role" "iam_common_role" {
  name               = "iam_common_role"
  assume_role_policy = "${file("iam/common_role_principal.json")}"
}

resource "aws_iam_policy" "common_role_policy" {
  name        = "common_role_policy"
  policy = "${file("iam/common_role_policy.json")}"
}

// Attach policy to IAM Role to Lambda Function
resource "aws_iam_role_policy_attachment" "iam_policy_attachment" {
  role       = "${aws_iam_role.iam_common_role.name}"
  policy_arn = "${aws_iam_policy.common_role_policy.arn}"
}