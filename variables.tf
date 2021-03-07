variable region {
  default = "eu-central-1"
}

variable profile {
  default = "lms"
}

variable lms_user_profile {
  default = "lmsuser"
}

variable prefix {
  default     = "lms"
  description = "organization or service name"
}

variable ddb_statelock_table {
  default     = "tf-statelock"
  description = "name of dynamo db table for terraform state locking"
}

variable ui_bucket_name {
  default     = "lms-ui-123"
  description = "name of the S3 bucket to hold UI related static assets"
}

variable ddb_books_table_name {
  default     = "Books"
  description = "name of dynamo db table"
}
