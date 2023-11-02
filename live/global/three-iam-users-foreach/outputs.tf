
# extract ARNs using values built-in function and splat expression
output "all_arns" {
  value = values(aws_iam_user.example)[*].arn
}


# contains map where keys are keys in for_each and values are all outputs for 
# that resource
output "all_users" {
  value = aws_iam_user.example
}