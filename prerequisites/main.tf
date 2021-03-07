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
# create S3 bucket that will be used for the backend
#-----------------------------------------------------------------------------------
resource aws_s3_bucket remote_state {
  bucket        = "lms-remote-state"
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
# S3 bucket that will be used for front-end
#-----------------------------------------------------------------------------------
resource aws_s3_bucket lmsfrontend {
  bucket = var.ui_bucket_name
  acl    = "public-read"

  versioning {
    enabled = true
  }

  website {
    error_document = "index.html"
    index_document = "index.html"
    routing_rules  = <<EOF
[{
  "Condition": {
    "KeyPrefixEquals": "*"
  },
  "Redirect": {
    "ReplaceKeyPrefixWith": "/"
  }
}]
EOF
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT", "POST"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }

  tags = {
    Name        = var.ui_bucket_name
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
#         "arn:aws:s3:::${aws_s3_bucket.remote_state.bucket}",
#         "arn:aws:s3:::${aws_s3_bucket.remote_state.bucket}/*"
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

