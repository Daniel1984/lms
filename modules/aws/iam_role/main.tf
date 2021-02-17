resource aws_iam_policy this {
  name        = "execute_${var.prefix}_lambda_policy"
  description = "policy to allow lambda use specified resources"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:*",
        "lambda:*",
        "dynamo:*",
        "dynamodb:*",
        "logs:*",
        "s3:*",
        "iam:*",
        "apigw:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource aws_iam_role this {
  name               = "execute_${var.prefix}_lambda"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "lambda.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }
}
POLICY
}

resource aws_iam_role_policy_attachment this {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

