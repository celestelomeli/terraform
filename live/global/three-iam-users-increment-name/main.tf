provider "aws" {
  region = "us-east-2"
}

# Create multiple AWS IAM users with unique names based on an index
resource "aws_iam_user" "example" {
  count = 3
  # count.index appends the index of each instance to create unique name for each user 
  name  = "${var.user_name_prefix}.${count.index}"
}