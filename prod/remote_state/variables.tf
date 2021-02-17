variable "region" {
  default = "eu-central-1"
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
