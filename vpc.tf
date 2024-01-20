module "vpc" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-vpc.git//"

  name = "ec2-vpc"

  cidr = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  flow_log_max_aggregation_interval    = 60
  create_flow_log_cloudwatch_iam_role  = true
  create_igw=true

  azs = ["us-east-1a","us-east-1b","us-east-1c"]

  enable_nat_gateway = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  private_subnet_tags = {
    Name = "ec2-vpc-private-subnet"
  }

  public_subnet_tags = {
    Name = "ec2-vpc-public-subnet"
  }

  private_route_table_tags = {
    Name = "ec2-vpc-private-rt"
  }

  public_route_table_tags = {
    Name = "ec2-vpc-public-rt"
  }

}
