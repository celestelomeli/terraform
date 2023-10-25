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