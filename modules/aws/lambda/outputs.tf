output "function_arn" {
  value = aws_lambda_function.this.arn
}

output "function_invoke_arn" {
  value = aws_lambda_function.this.invoke_arn
}

output "function_name" {
  value = aws_lambda_function.this.function_name
}
