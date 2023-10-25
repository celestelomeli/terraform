provider "aws" {
    region = "us-east-2"
}


# Creates a database in RDS 
resource "aws_db_instance" "example" {
    identifier_prefix = "terraform-up-and-running"
    engine = "mysql"  #database engine
    allocated_storage = 10 #GB of storage
    instance_class = "db.t2.micro"  
    skip_final_snapshot = true
    db_name = var.db_name

    # How should we set the username and password/secrets?
    username = var.db_username
    password = var.db_password
}

# Configure terraform to store state in S3 bucket (encryption and locking) w/ backend configuration
terraform {
  backend "s3" {
    bucket = "lrofpqx"
    # filepath in s3 bucket where tf state file written
    key = "stage/data-stores/mysql/terraform.tfstate"
    region = "us-east-2"

    #dynamodb table
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt = true
  }
  
}

