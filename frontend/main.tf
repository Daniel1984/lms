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
    bucket         = "ui-remote-state"
    key            = "book_ui.tfstate"
    profile        = "lms"
    dynamodb_table = "tf-statelock"
  }
}

#-----------------------------------------------------------------------------------
# S3 bucket that will be used to host static files
#-----------------------------------------------------------------------------------
data template_file ui_bucket_policy {
  template = file("templates/bucket_polict.tpl")
  vars     = {
    bucket_name = var.ui_bucket_name
  }
}

resource aws_s3_bucket lmsfrontend {
  bucket        = var.ui_bucket_name
  acl           = "public-read"
  force_destroy = true
  policy        = data.template_file.ui_bucket_policy.rendered

  versioning {
    enabled = true
  }

  website {
    error_document = "index.html"
    index_document = "index.html"
  }

  tags = {
    Name        = var.ui_bucket_name
    Environment = terraform.workspace
  }
}

resource "aws_s3_bucket_object" "object" {
  bucket   = aws_s3_bucket.lmsfrontend.id
  for_each = fileset("build/", "**")
  key      = each.value
  source   = "build/${each.value}"
  etag     = filemd5("build/${each.value}")
}
