provider "aws" {
  region  = var.region
  profile = var.profile
}

#-----------------------------------------------------------------------------------
# BACKEND SETUP FOR STATE TRACKING
#-----------------------------------------------------------------------------------
terraform {
  backend "s3" {
    region  = "eu-central-1"
    bucket  = "lms-remote-state-prod"
    key     = "terraform.tfstate"
    profile = "lms"
  }
}

#-----------------------------------------------------------------------------------
# STACK ROLE FOR EXECUTING LAMBDAS, ACCESSING RESOURCES ETC
#-----------------------------------------------------------------------------------
module execute_lms_role {
  source = "../modules/aws/iam_role"
  prefix = var.prefix
}

#-----------------------------------------------------------------------------------
# S3 BUCKET FOR FRONTEND
#-----------------------------------------------------------------------------------
resource aws_s3_bucket lmsfrontend {
  bucket = "lmsfrontend-1234567"
  acl = "public-read"

  versioning {
    enabled = true
  }

  tags = {
    Name = "${var.prefix}-lmsfrontend-1234567-${var.env}"
    Environment = var.env
  }
}

#-----------------------------------------------------------------------------------
# INSERT BOOK LAMBDA
#-----------------------------------------------------------------------------------
module insert_book_lambda {
  source        = "../modules/aws/lambda"
  function_name = "insertbook"
  description   = "insert book lambda, part of books resource CRUD to create new book instance"
  role_arn      = module.execute_lms_role.execute_lambda_arn

  environment = {
    ENV        = var.env
    REGION     = var.region
    TABLE_NAME = var.table_name
  }

  tags = {
    Environment = var.env
  }
}

#-----------------------------------------------------------------------------------
# UPDATE BOOK LAMBDA
#-----------------------------------------------------------------------------------
module update_book_lambda {
  source        = "../modules/aws/lambda"
  function_name = "updatebook"
  description   = "update book lambda, part of books resource CRUD to update book instance"
  role_arn      = module.execute_lms_role.execute_lambda_arn

  environment = {
    ENV        = var.env
    REGION     = var.region
    TABLE_NAME = var.table_name
  }

  tags = {
    Environment = var.env
  }
}

#-----------------------------------------------------------------------------------
# GET BOOKS LAMBDA
#-----------------------------------------------------------------------------------
module get_books_lambda {
  source        = "../modules/aws/lambda"
  function_name = "getbooks"
  description   = "get books lambda, part of books resource CRUD to retrieve all books"
  role_arn      = module.execute_lms_role.execute_lambda_arn

  environment = {
    ENV        = var.env
    REGION     = var.region
    TABLE_NAME = var.table_name
  }

  tags = {
    Environment = var.env
  }
}

#-----------------------------------------------------------------------------------
# DELETE BOOK LAMBDA
#-----------------------------------------------------------------------------------
module delete_book_lambda {
  source        = "../modules/aws/lambda"
  function_name = "deletebook"
  description   = "delete book lambda, part of books resource CRUD to delete book"
  role_arn      = module.execute_lms_role.execute_lambda_arn

  environment = {
    ENV        = var.env
    REGION     = var.region
    TABLE_NAME = var.table_name
  }

  tags = {
    Environment = var.env
  }
}

#-----------------------------------------------------------------------------------
# BOOKS API GATEWAY
#-----------------------------------------------------------------------------------
resource aws_api_gateway_rest_api api {
  name = "LMSAPI"
}

resource aws_api_gateway_resource resource {
  path_part   = "books"
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
}

resource aws_api_gateway_deployment apideploy {
   depends_on  = [
     aws_api_gateway_integration.insertbook,
     aws_api_gateway_integration.updatebook,
     aws_api_gateway_integration.getbooks,
     aws_api_gateway_integration.deletebook,
   ]
   rest_api_id = aws_api_gateway_rest_api.api.id
   stage_name  = var.env
}

# ----------------------------------------
# POST /books
# ----------------------------------------
resource aws_api_gateway_method insertbook {
   http_method   = "POST"
   authorization = "NONE"
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.resource.id
}

resource aws_api_gateway_integration insertbook {
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   rest_api_id             = aws_api_gateway_rest_api.api.id
   resource_id             = aws_api_gateway_resource.resource.id
   http_method             = aws_api_gateway_method.insertbook.http_method
   uri                     = module.insert_book_lambda.function_invoke_arn
}

resource aws_lambda_permission insertbookapigw {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   principal     = "apigateway.amazonaws.com"
   function_name = module.insert_book_lambda.function_name
   source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/${var.env}/POST/${aws_api_gateway_resource.resource.path_part}"
}

# ----------------------------------------
# PUT /books
# ----------------------------------------
resource aws_api_gateway_method updatebook {
   http_method   = "PUT"
   authorization = "NONE"
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.resource.id
}

resource aws_api_gateway_integration updatebook {
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   rest_api_id             = aws_api_gateway_rest_api.api.id
   resource_id             = aws_api_gateway_resource.resource.id
   http_method             = aws_api_gateway_method.updatebook.http_method
   uri                     = module.update_book_lambda.function_invoke_arn
}

resource aws_lambda_permission updatebookapigw {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   principal     = "apigateway.amazonaws.com"
   function_name = module.update_book_lambda.function_name
   source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/${var.env}/PUT/${aws_api_gateway_resource.resource.path_part}"
}

# ----------------------------------------
# GET /books
# ----------------------------------------
resource aws_api_gateway_method getbooks {
   http_method   = "GET"
   authorization = "NONE"
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.resource.id
}

resource aws_api_gateway_integration getbooks {
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   rest_api_id             = aws_api_gateway_rest_api.api.id
   resource_id             = aws_api_gateway_resource.resource.id
   http_method             = aws_api_gateway_method.getbooks.http_method
   uri                     = module.get_books_lambda.function_invoke_arn
}

resource aws_lambda_permission apigw {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   principal     = "apigateway.amazonaws.com"
   function_name = module.get_books_lambda.function_name
   source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/${var.env}/GET/${aws_api_gateway_resource.resource.path_part}"
}

# ----------------------------------------
# DELETE /books
# ----------------------------------------
resource aws_api_gateway_method deletebook {
   http_method   = "DELETE"
   authorization = "NONE"
   rest_api_id   = aws_api_gateway_rest_api.api.id
   resource_id   = aws_api_gateway_resource.resource.id
}

resource aws_api_gateway_integration deletebook {
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   rest_api_id             = aws_api_gateway_rest_api.api.id
   resource_id             = aws_api_gateway_resource.resource.id
   http_method             = aws_api_gateway_method.deletebook.http_method
   uri                     = module.delete_book_lambda.function_invoke_arn
}

resource aws_lambda_permission deletebookapigw {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   principal     = "apigateway.amazonaws.com"
   function_name = module.delete_book_lambda.function_name
   source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/${var.env}/DELETE/${aws_api_gateway_resource.resource.path_part}"
}

output books_resource_url {
  value = "${aws_api_gateway_deployment.apideploy.invoke_url}/${aws_api_gateway_resource.resource.path_part}"
}

#-----------------------------------------------------------------------------------
# BOOKS DYNAMO DB
#-----------------------------------------------------------------------------------
module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name      = var.table_name
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
    Environment = var.env
  }
}

