provider aws {
  region  = var.region
  profile = var.profile
}

#-----------------------------------------------------------------------------------
# variables
#-----------------------------------------------------------------------------------
# variable creds_path {
#   description = "path to .aws/credentials"
# }

#-----------------------------------------------------------------------------------
# create dynamo db for shared state locking
#-----------------------------------------------------------------------------------
resource aws_dynamodb_table terraform_statelock {
  name           = var.ddb_statelock_table
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

#-----------------------------------------------------------------------------------
# create S3 bucket that will be used for the api backend state management
#-----------------------------------------------------------------------------------
resource aws_s3_bucket api_remote_state {
  bucket        = "api-remote-state"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Environment = terraform.workspace
  }
}

#-----------------------------------------------------------------------------------
# create S3 bucket that will be used for the UI backend state management
#-----------------------------------------------------------------------------------
resource aws_s3_bucket ui_remote_state {
  bucket        = "ui-remote-state"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  tags = {
    Environment = terraform.workspace
  }
}

#-----------------------------------------------------------------------------------
# Creating new profiles and assigning access rights
#-----------------------------------------------------------------------------------
# resource aws_iam_user lmsuser {
#   name = var.lms_user_profile
# }
#
# resource aws_iam_access_key lmsuser {
#   user = aws_iam_user.lmsuser.name
# }

# resource aws_iam_group_membership lmsuser {
#   name  = "add-new-dev-user"
#
#   users = [
#     aws_iam_user.lmsuser.name
#   ]
#
#   group = "admin"
# }

# resource aws_iam_user_policy lmsuser {
#   name   = aws_iam_user.lmsuser.name
#   user   = aws_iam_user.lmsuser.name
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Action": "S3:*",
#       "Resource": [
#         "arn:aws:s3:::${aws_s3_bucket.api_remote_state.bucket}",
#         "arn:aws:s3:::${aws_s3_bucket.api_remote_state.bucket}/*"
#       ]
#     },
#     {
#       "Effect": "Allow",
#       "Action": "dynamodb:*",
#       "Resource": [
#         "${aws_dynamodb_table.terraform_statelock.arn}"
#       ]
#     }
#   ]
# }
# EOF
# }

# resource local_file aws_keys {
#   filename = "${var.creds_path}/.aws/creds"
#   content  = <<EOF
# [${var.lms_user_profile}]
# aws_access_key_id = ${aws_iam_access_key.lmsuser.id}
# aws_secret_access_key = ${aws_iam_access_key.lmsuser.secret}
# output = json
# region = ${var.region}
#
# EOF
# }

