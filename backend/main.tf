provider "aws" {
  region  = var.region
  profile = var.profile
}

#-----------------------------------------------------------------------------------
# Backend setup for state tracking, check prerequisites
#-----------------------------------------------------------------------------------
terraform {
  backend "s3" {
    region         = "eu-central-1"
    bucket         = "api-remote-state"
    key            = "book_api.tfstate"
    profile        = "lms"
    dynamodb_table = "tf-statelock"
  }
}

#-----------------------------------------------------------------------------------
# Role for executing lambdas and accessing resources etc
#-----------------------------------------------------------------------------------
data template_file api_lambda_policy {
  template = file("templates/lambda_policy.tpl")
}

data template_file api_lambda_role {
  template = file("templates/lambda_role.tpl")
}

resource aws_iam_policy lms {
  name        = "execute_lms_lambda_policy"
  description = "policy to allow lambda use specified resources"
  policy      = data.template_file.api_lambda_policy.rendered
}

resource aws_iam_role lms {
  name               = "execute_lms_lambda"
  assume_role_policy = data.template_file.api_lambda_role.rendered
}

resource aws_iam_role_policy_attachment lms {
  role       = aws_iam_role.lms.name
  policy_arn = aws_iam_policy.lms.arn
}

#-----------------------------------------------------------------------------------
# Create Dynamodb table for books resource
#-----------------------------------------------------------------------------------
module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name      = "${var.ddb_books_table_name}-${terraform.workspace}"
  hash_key  = "id"
  range_key = "author"

  attributes = [
    {
      name = "id"
      type = "S"
    },
    {
      name = "author"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = terraform.workspace
  }
}

#-----------------------------------------------------------------------------------
# Create insert book lambda
#-----------------------------------------------------------------------------------
module insert_book_lambda {
  source        = "../modules/aws/lambda"
  function_name = "insertbook"
  description   = "insert book lambda, part of books resource CRUD to create new book instance"
  role_arn      = aws_iam_role.lms.arn

  environment = {
    ENV        = terraform.workspace
    REGION     = var.region
    TABLE_NAME = "${var.ddb_books_table_name}-${terraform.workspace}"
  }

  tags = {
    Environment = terraform.workspace
  }
}
