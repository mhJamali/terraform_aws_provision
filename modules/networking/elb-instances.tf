resource "aws_instance" "webservers" {
	ami             = var.instance-ami
	instance_type   = var.instance_type
	security_groups = [aws_security_group.webservers.id]
  count           = length(var.public_subnets_cidr)
	subnet_id       = element(aws_subnet.public_subnet.*.id, count.index)
	user_data       = file("install_httpd.sh")

	tags = {
	  Name = "Server-${count.index}"
	}
}
