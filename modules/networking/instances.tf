resource "random_shuffle" "subnet_pickler" {
  input = aws_subnet.public_subnet.*.id
  result_count = 1
}

# create a bastion host - ec2 instance in public subnet
resource "aws_instance" "bastion-instance" {
  depends_on = [
  aws_security_group.default,
  ]
  ami           = var.instance-ami
  instance_type = "t2.micro"
  subnet_id     = element(random_shuffle.subnet_pickler.result, 0)
  #vpc_security_group_ids = [aws_security_group.allow-ssh.id]
  vpc_security_group_ids = [aws_security_group.default.id]
  #key_name = aws_key_pair.mykeypair.key_name
  key_name = aws_key_pair.key_pair.key_name

  tags = {
    Name = "bastion-instance"
  }
  provisioner "file" {
    source      = "/home/terraform-lab/ec2Key.pem"
    destination = "/home/ec2-user/ec2Key.pem"

    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = tls_private_key.private_key.private_key_pem
    host     = element(aws_instance.bastion-instance.*.public_ip, 0)
    }
  }
}

# this will create ec2 instance in private subnet
resource "aws_instance" "private-instance" {
  ami           = var.instance-ami
  instance_type = "t2.micro"
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  vpc_security_group_ids = [aws_security_group.default.id]
  #key_name = aws_key_pair.mykeypair.key_name
  key_name = aws_key_pair.key_pair.key_name

  tags = {
    Name = "private-instance"
  }
}

# this will create a key with RSA algorithm with 4096 rsa bits
resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# this resource will create a key pair using above private key
resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.private_key.public_key_openssh
  depends_on = [tls_private_key.private_key]
}

# this resource will save the private key at our specified path.
resource "local_file" "saveKey" {
  content = tls_private_key.private_key.private_key_pem
  filename = "${var.base_path}${var.key_name}.pem"

}
