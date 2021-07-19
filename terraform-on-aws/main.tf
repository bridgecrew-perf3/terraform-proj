provider "aws" {
  region = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}
#S3 bucket for aws
resource "aws_s3_bucket" "sakarbucket" {
  bucket = "sakarbucket"
  acl    = "private"
  tags = {
    Name        = "Terraform Bucket"
    Environment = "Dev"
  }
}
# AWS EC2 Key-Pair
resource "aws_key_pair" "test_key_pair" {
  key_name   = "test_key_pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCM/YN2popcArAvLW9G0YgzWfR4wSyHwa/wwGMKeUxHcU+Drlm40zBlHcj8Jga8x7xhu710A4d6JHogyJHogEu3rm3mfoyte2GvmhinIecvmNTxAhxvWmJRNsa31a0blYPWVPQzMLydALLToVJ7BILwBfsG2bqZrYXu8bObAQhLiQMUYAiTpSC3Ywa7iHdRE49WjxOZVaB1qwIL5n1kZAaUjVF/qtsSxvkTJ8pcejABGmk4sxOUEFNBJ9Ya/xo/+E3QGmZY7fqCZOat8nn85hcplxc8UCefHuSMvUWHlqkRDACYgRHaUbiU7kjcKx6XTGWRNdTBdFIl1l0P4zQN12l7 rsa-key-20210718"
}

#Security Group
variable "vpc_id" {
  default = "vpc-4d543930"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic ."
  vpc_id      = "${var.vpc_id}"

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["172.31.0.0/16"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

#aws instance
resource "aws_instance" "web" {
  ami           = "${var.ami_id}"
  instance_type = "t3.micro"
  key_name = "${aws_key_pair.test_key_pair.key_name}"
  vpc_security_group_ids = [ "${aws_security_group.allow_tls.id}" ]
  tags = {
    Name = "HelloWorld"
  }
}

