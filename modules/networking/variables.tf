variable "environment" {
  description = "The Deployment environment"
  default  = "Test"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
  default     = "10.0.0.0/16"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
  default     =["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets_cidr" {
  type        = list
  description = "The CIDR block for the private subnet"
  default     = ["10.0.10.0/24"]
}

variable "region" {
  description = "The region to launch the bastion host"
  default = "us-east-1"
}

variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable instance-ami {
    default="ami-0915bcb5fa77e4892"
}

variable "instance_type" {
  default = "t2.micro"
}

/*
variable key_path {
    default = "keys/mykeypair.pub"
    #default = "~/.ssh/mykeypair.pub"
}
*/
############

# key variable for refrencing
variable "key_name" {
  default = "ec2Key"      # if we keep default blank it will ask for a value when we execute terraform apply
}

# base_path for refrencing
variable "base_path" {
  default = "/home/terraform-lab/"
}
