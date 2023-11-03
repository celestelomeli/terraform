 # Backend block specifies how Terraform should store its state file
terraform {
  backend "s3" {
    bucket = "lrofpqx"
    # filepath within s3 bucket where tf state file stored
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"

    # Configure DynamoDB table for state locking (one user at a time can apply changes)
    dynamodb_table = "terraform-up-and-running-locks"
    # enabled for state file
    encrypt = true
  }
}

# Define AWS provider config
provider "aws" {
  region = "us-east-2"
}

# Define an AWS RDS (Relational Database Service) instance resource 
resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  # final db snapshot is backup of database at point just before instance is removed 
  skip_final_snapshot = true
}