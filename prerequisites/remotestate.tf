provider "aws" {
  region  = var.region
  profile = var.profile
}

# ----------------------------------------------------
# create dynamo db for shared state locking 
# ----------------------------------------------------
resource "aws_dynamodb_table" "terraform_statelock" {
  name           = var.ddb_statelock_table 
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

# ----------------------------------------------------
# create S3 bucket that will be used for the backend
# ----------------------------------------------------
resource "aws_s3_bucket" "remote_state" {
  bucket        = "${var.prefix}-remote-state-${terraform.workspace}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Environment = terraform.workspace
  }
}

# data "aws_iam_group" "ec2admin" {
#   group_name = "EC2Admin"
# }

resource "aws_iam_user" "lmsuser" {
  name = "lmsuser"
}

resource "aws_iam_access_key" "lmsuser" {
  user = aws_iam_user.lmsuser.name
}

resource "aws_iam_user_policy" "lmsuser" {
  name   = aws_iam_user.lmsuser.name
  user   = aws_iam_user.lmsuser.name
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "S3:*",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.remote_state.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.remote_state.bucket}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "dynamodb:*",
      "Resource": [
        "${aws_dynamodb_table.terraform_statelock.arn}"
      ]
    }
  ]
}
EOF
}
