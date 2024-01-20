locals {
  user_data = <<-EOT
    #!/bin/bash

    sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -a -G docker $(whoami)
wget https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)
sudo mv docker-compose-$(uname -s)-$(uname -m) /usr/local/bin/docker-compose
sudo chmod -v +x /usr/local/bin/docker-compose
sudo systemctl enable docker.service
sudo systemctl start docker.service

# Display Docker and Docker Compose versions
docker --version
docker-compose --version


  EOT
}

module "ec2_security_group" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-security-group.git//?ref=v5.1.0"

  name        = "ec2-sg"
  description = "Security group for EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "all-icmp","ssh-tcp","mysql-tcp"]
  egress_rules        = ["all-all"]

}

module "ec2" {
  source                 = "git::https://github.com/terraform-aws-modules/terraform-aws-ec2-instance.git//?ref=v5.2.1"
  name                   = "ec2-instance"
  ami                    = "ami-0005e0cfe09cc9050"
  instance_type          = "t2.micro"
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = [module.ec2_security_group.security_group_id]
  associate_public_ip_address=true
  key_name      = "keppair-ec2"

  create_iam_instance_profile = true
  iam_role_description        = "IAM role for EC2 instance"
  iam_role_policies = {
    EC2InstanceAccess = module.ec2_iam_policy.arn,
    EC2SSMAccess      = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  }

  user_data_base64 = base64encode(local.user_data)
}

