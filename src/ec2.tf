resource "tls_private_key" "deployer_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer_key_pair" {
  key_name   = "onway-key-pair"
  public_key = tls_private_key.deployer_key.public_key_openssh
}

resource "aws_instance" "onway_server" {
  ami           = "ami-0a9f9a5c792cad8b4" //Debian
  instance_type = "t2.micro"
  key_name      = aws_key_pair.deployer_key_pair.key_name

  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]

  tags = {
    Name = "onway-server"
  }
}
