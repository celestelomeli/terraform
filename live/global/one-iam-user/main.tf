provider "aws" {
  region = "us-east-2"
}

# Create an AWS IAM user resource with specified name
resource "aws_iam_user" "example" {
  # Set IAM user's name to value of "user_name" variable
  name = var.user_name

}