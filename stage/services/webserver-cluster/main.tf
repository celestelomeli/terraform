provider "aws" {
  region = "us-east-2"
}


terraform {
  backend "s3" {
    bucket = "lrofpqx"
    # filepath in s3 bucket where tf state file written
    key    = "stage/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"

    #dynamodb table
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}

module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"
  # https://github.com/celestelomeli/modules
  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
}


resource "aws_security_group_rule" "allow_testing_inbound" {
  type              = "ingress"
  security_group_id = module.webserver_cluster.alb_security_group_id

  from_port   = 12345
  to_port     = 12345
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
