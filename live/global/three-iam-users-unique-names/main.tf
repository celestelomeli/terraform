provider "aws" {
  region = "us-east-2"
}

# Create AWS IAM users based on list of user names 
resource "aws_iam_user" "example" {
  # specifies that number of IAM users created will be equal to length of user_names list
  count = length(var.user_names)
  # sets name of each IAM user
  name  = var.user_names[count.index]
}

# Create an IAM policy with specific permissions
resource "aws_iam_policy" "cloudwatch_read_only" {
  # name of IAM policy 
  name   = "${var.policy_name_prefix}cloudwatch-read-only"
 # associates IAM policy with JSON document defin in pocily doc data block with read only access
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

data "aws_iam_policy_document" "cloudwatch_read_only" {
  # specifies permissions within the policy using statement block allowing various actions related to cloudwatch resources 
  statement {
    effect    = "Allow"
    actions   = [
      "cloudwatch:Describe*",
      "cloudwatch:Get*",
      "cloudwatch:List*"
    ]
    #allows these actions for all cloudwatch resources 
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloudwatch_full_access" {

  name   = "${var.policy_name_prefix}cloudwatch-full-access"

  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

data "aws_iam_policy_document" "cloudwatch_full_access" {
  statement {
    effect    = "Allow"
    actions   = ["cloudwatch:*"]
    resources = ["*"]
  }
}

# Attach a full access CloudWatch policy to an IAM user if "give_neo_cloudwatch_full_access" is true
# full access if true
resource "aws_iam_user_policy_attachment" "neo_cloudwatch_full_access" {
 # if true one instance created otherwise set to 0
  count = var.give_neo_cloudwatch_full_access ? 1 : 0
# attaches policy to IAM user with name specified
  user       = aws_iam_user.example[0].name
  # attaches the cloudwatch full access policy to IAM user
  # arn references ARN of policy created earlier
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

# readonly access if false
resource "aws_iam_user_policy_attachment" "neo_cloudwatch_read_only" {
  # sets count to 1 if false 
  count = var.give_neo_cloudwatch_full_access ? 0 : 1

  user       = aws_iam_user.example[0].name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}

# resources allow you to conditionally attach IAM policies to an IAM user based on 
# the value of "give_neo_cloudwatch_full_access" 