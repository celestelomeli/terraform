provider "aws" {
  region = "us-east-2"
}

# # Convert var.user_names list into set; each username available in "each.value"
# resource "aws_iam_user" "example" {
#   for_each = toset(var.user_names)
#   name     = each.value
# }

# Instantiate an IAM user module for each specified user name 
module "users" {
  source = "../../../modules/landing-zone/iam-user"

  for_each  = toset(var.user_names) # Create an instance of the module for each user name in the set 
  user_name = each.value # Set the "user_name" variable in the module to the current user name 
}