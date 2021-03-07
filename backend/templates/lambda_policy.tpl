{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:*",
        "lambda:*",
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
