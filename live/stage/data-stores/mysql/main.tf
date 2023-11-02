provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    bucket = "lrofpqx"
    # filepath in s3 bucket where tf state file written
    key    = "stage/services/data-stores/terraform.tfstate"
    region = "us-east-2"

    #dynamodb table
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

# Creates a database in RDS 
resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running"
  engine              = "mysql" #database engine
  allocated_storage   = 10      #GB of storage
  instance_class      = "db.t2.micro"
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
  skip_final_snapshot = true
}



#configures web server cluster to read state file from same s3 bucket/folder where
#database stores its state
# data "terraform_remote_state" "db" {
#     backend = "s3"

#     config = {
#         bucket = "lrofpqx"
#         key = "stage/data-stores/mysql/terraform.tfstate"
#         region = "us-east-2"
#     }
# }