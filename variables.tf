variable "region" {
  default = "eu-central-1"
}

variable "profile" {
  default = "lms2"
}

variable "prefix" {
  default     = "lms"
  description = "organization or service name"
}

variable "ddb_statelock_table" {
  default     = "tf-statelock"
  description = "name of dynamo db table for terraform state locking"
}
