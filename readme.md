#Terraform | Create VPC, subnets, compute instances, elb, autoscaling, security groups etc.....
Terraform is so popular nowadays. Terraform enables you to create and manage infrastructure with code and codes can be stored in version control.

we are creating 1 VPC, multiple subnets(Public and Private), 1 Internet gateway, security groups, In addition, we will create Custom Route Tables and associate them with subnets with NAT gateway support. Also we will configure elb and autoscaling.
Let's start!

Pre-Requisites To Creating Infrastructure on AWS Using Terraform
  1. We require AWS IAM API keys (access key and secret key) for creating and deleting permissions for all AWS resources.
  2. Terraform should be installed on the machine.

#Amazon Resources Created Using Terraform
AWS VPC with 10.0.0.0/16 CIDR.
Multiple AWS VPC public subnets would be reachable from the internet; which means traffic from the internet can hit a machine in the public subnet.
Multiple AWS VPC private subnets which mean it is not reachable to the internet directly without NAT Gateway.
AWS VPC Internet Gateway and attach it to AWS VPC.
Public and private AWS VPC Route Tables.
AWS VPC NAT Gateway.
Associating AWS VPC Subnets with VPC route tables.

1. Create a "provider.tf"
This is the provider file that tell Terraform to which provider you are using. All infrastructure will be on the AWS because of provider "aws".

2. Create "variables.tf"
All variables will be in this file. Input variables are like function arguments. just declare all variables that we are using in main.tf a file so we can use get all variables value from production.tf file.

3. Create "modules > Networking" Folder
A module is a container for multiple resources that are used together. Modules can be used to create lightweight abstractions, so that you can describe your infrastructure in terms of its architecture, rather than directly in terms of physical objects.

4. Create "Main.tf".
In main.tf configured vpc, subnets, Internet gateway, Route table,
`VPC`:- An Amazon VPC (virtual private cloud) is an isolated section of the AWS cloud where you can provision your infrastructure.
`Subnets`:- Subnets are essentially subsets of available addresses in your VPC and add an extra layer of control and security to resources in your environment. I launched both public and private subnet, inside private subnet compute instance is there and in public subnet configured elb. The key differentiator between a private and public subnet is the "map_public_ip_on_launch" flag, if this is True, instances launched in this subnet will have a public IP address and be accessible via the internet gateway.
`Internet Gateway`:- For a subnet to be accessible to the internet an AWS internet gateway is required. An internet gateway allows internet traffic to and from your VPC.
`Route table`:- A Route table specifies which external IP address are contactable from a subnet or internet gateway.
`Nat Gateway`:- A Nat Gateway enables instances in private subnets to connect to the internet. The Nat gateway must be deployed in the public subnet with an Elastic IP. Once the resource is created, a route table associated with the private subnet needs to point internet-bound traffic to the NAT gateway.
`Security Groups`:- A security group acts as a virtual firewall for your instance to control incoming and outgoing traffic. The security group below enables all traffic over port 22 (SSH). Both instances in the private and public subnet require this security group.
`Ec2 Instances and Keys`:- After all the necessary infrastructure has been defined, we can set up our Ec2 instances. The instances require an AWS key-pair to authenticate access which is created below using the aws_key_pair resource and existing ssh key.

5. Create "production.tf"
Production.tf files in your working directory when you run terraform plan or terraform apply together form the root module. That module may call other modules and connect them by passing output values from one to the input values of another.

6. Create "Output.tf"
We can export any details from created resources and give that as an input of another module. Output values are like function return values.

7. create "instances.tf"
Create ec2 instance in private subnet and for accessing this create a bastion-host instance in public subnet.
Lets start with elb part

8. create "elb.tf"
Create a Elastic Load Balancer to automatically distributes incoming application traffic across multiple Amazon EC2 instances.

9. create "elb-security-groups.tf"
create a security group for our web servers with inbound allowing port 80 and with outbound allowing all traffic:

10. create "elb-instances.tf"
create our web severs. We added ami, security groups, subnet, user_data.

11. create "install_httpd.sh"
The boot strapping script for our user_data is defined in install_httpd.sh.

12. create "autoscaling.tf"
Used Terraform module "autoscaling" and source "terraform-aws-modules/autoscaling/aws" to provision Auto Scaling Group and Launch Template on AWS.

Now that the infrastructure is complete the next step is to deploy. This can be achieved with the following Terraform commands in the terraform directory:
$ terraform init -  The `terraform init` download all modules information and download terraform in your project file. This command will initialize modules, backend and provider plugins.
$ terraform plan - The `terraform plan` a command is used to create an execution plan. Terraform performs a refresh, unless explicitly disabled, and then determines what actions are necessary to achieve the desired state specified in the configuration files. This command is a convenient way to check whether the execution plan for a set of changes matches your expectations without making any changes to real resources or the state. For example, terraform plan might be run before committing a change to version control, to create confidence that it will behave as expected.
$ terraform apply - The `terraform apply` a command is used to apply the changes required to reach the desired state of the configuration, or the pre-determined set of actions generated by a terraform plan execution plan.
