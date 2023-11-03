provider "aws" {
  region = "us-east-2"
}

# Create 3 EC2 instances using the same AMI and instance type (fixed count)
resource "aws_instance" "example_1" {
  count         = 3  # create 3 instances 
  ami           = "ami-0fb653ca2d3203ac1"  # AMI to use
  instance_type = "t2.micro"  # EC2 instance type
}


# number of instances created dynamically based on number of available availabilty zones in AWS region
# retrieves availability zone names using data source
# for each zone an EC2 instance created 
# count creates three instances with same AMI and instance type
resource "aws_instance" "example_2" {
  count             = length(data.aws_availability_zones.all.names)
  availability_zone = data.aws_availability_zones.all.names[count.index]
  ami               = "ami-0fb653ca2d3203ac1"
  instance_type     = "t2.micro"
}

# retrieve information about all available AWS availability zones in the region 
data "aws_availability_zones" "all" {}