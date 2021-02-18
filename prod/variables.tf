variable "region" {
  default = "eu-central-1"
}

variable "api_deployed_at" {
  description = "api gateway deployment ts"
}

variable "accountId" {
  default = "173666726976"
}

variable "profile" {
  default = "lms"
}

variable "prefix" {
  default     = "lms"
  description = "organization or service name"
}

variable "env" {
  default     = "prod"
  description = "the name of the environment, i.e. staging, prod"
}

variable "table_name" {
  default     = "Books"
  description = "name of dynamo db table"
}
