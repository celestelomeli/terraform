provider "aws" {
  region = "us-east-2"
}

# Instantiate an IAM user module for each user name specified in the list
module "users" {
  source = "../../../modules/landing-zone/iam-user"

  # create instance of module for each user name specified in user_names variable
  count     = length(var.user_names)
  # count.index iterates through list of user names and for each instance of module 
  # assigns specific user name to variable, creating distinct names 
  user_name = var.user_names[count.index]
}