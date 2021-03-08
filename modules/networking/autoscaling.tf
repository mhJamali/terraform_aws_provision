
data "aws_vpc" "vpc" {
  tags={
  Environment = var.environment
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.vpc.id
}
/*
data "aws_security_group" "sg" {
  tags={
  Name = "Test-sg"
  }
}
*/

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"
    values = [
      "amazon",
    ]
  }
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = "something"

  # Sometimes good sleep is required to have some IAM resources created before they can be used
 /*
  provisioner "local-exec" {
    command = "sleep 10"
  }*/
}

locals {

  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
EOF
}

######
# Launch configuration and autoscaling group
######
module "autoscaling" {
   source  = "terraform-aws-modules/autoscaling/aws"
   version = "3.9.0"

  name = "autoscale-server"
  # launch_configuration = "my-existing-launch-configuration" # Use the existing launch configuration
  # create_lc = false # disables creation of launch configuration
  lc_name = "example-lc"

  image_id                     = data.aws_ami.amazon_linux.id
  instance_type                = "t2.micro"
  #security_groups              = [data.aws_security_group.sg.id]
  security_groups              = [aws_security_group.default.id]
  associate_public_ip_address  = true
  recreate_asg_when_lc_changes = true
  user_data_base64 = base64encode(local.user_data)

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size           = "50"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]

  # Auto scaling group
  asg_name                  = "example-asg"
  vpc_zone_identifier       = data.aws_subnet_ids.public.ids
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

  tags = [
    {
      key                 = "Environment"
      value               = "Test"
      propagate_at_launch = true
    },
    {
      key                 = "description"
      value               = "autoscaling configuration"
      propagate_at_launch = true
    }
  ]
}
