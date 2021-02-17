resource "aws_s3_bucket" "remote_state" {
  bucket = "${var.prefix}-remote-state-${var.environment}"
  acl = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name = "${var.prefix}-remote-state-${var.environment}"
    Environment = var.environment
  }
}
