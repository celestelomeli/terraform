provider "aws" {
  region = "us-east-2"
}

# # Convert var.user_names list into set; each username available in "each.value"
# resource "aws_iam_user" "example" {
#   for_each = toset(var.user_names)
#   name     = each.value
# }

module "users" {
  source = "../../../modules/landing-zone/iam-user"

  for_each  = toset(var.user_names)
  user_name = each.value
}