

provider "aws" {
  region = "us-east-2"
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
  source = "github.com/celestelomeli/modules//services/webserver-cluster?ref=v.0.0.1"

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type = "t2.micro"
  min_size      = 2
  max_size      = 10
}

# Define scheduled action
resource "aws_autoscaling_schedule" "scale_out_during_business_hours" {
  scheduled_action_name = "scale-out-during-business-hours"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 10
  recurrence            = "0 9 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

resource "aws_autoscaling_schedule" "scale_in_at_night" {
  scheduled_action_name = "scale-in-at-night"
  min_size              = 2
  max_size              = 10
  desired_capacity      = 2
  recurrence            = "0 17 * * *"

  autoscaling_group_name = module.webserver_cluster.asg_name
}

