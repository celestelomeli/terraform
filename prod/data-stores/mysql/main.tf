 

terraform {
  backend "s3" {
    bucket = "lrofpqx"
    # filepath in s3 bucket where tf state file written
    key = "prod/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"

    #dynamodb table
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
}

provider "aws" {
  region = "us-east-2"
}


resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}