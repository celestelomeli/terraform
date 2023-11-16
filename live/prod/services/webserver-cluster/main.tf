

provider "aws" {
  region = "us-east-2"

   # Tags to apply to all AWS resources by default
  default_tags {
    tags = {
      Owner     = "celestelomeli"
      ManagedBy = "Terraform"
     }
  }
}

terraform {
  backend "s3" {
    bucket = "lrofpqx"
    # filepath in s3 bucket where tf state file written
    key    = "prod/services/webserver-cluster/terraform.tfstate"
    region = "us-east-2"

    #dynamodb table
    dynamodb_table = "terraform-up-and-running-locks"
    encrypt        = true
  }
}


module "webserver_cluster" {
  source = "github.com/celestelomeli/modules//services/webserver-cluster?ref=v0.0.3"

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 2
  # ASG will automatically adjust number of instances based on demand
  enable_autoscaling = true # var.enable_autoscaling

  # custom tags to apply to instances launched within module
  custom_tags = {
    Owner = "celestelomeli"
    ManagedBy = "terraform"
  }
}
