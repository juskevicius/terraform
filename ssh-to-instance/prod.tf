variable "prod_public_key_name" {
  type = string
}

provider "aws" {
  profile = "terraform"
  region  = "eu-north-1"
}

resource "aws_vpc" "prod_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "prod_vpc"
    "Terraform" = "true"
  }
}

resource "aws_subnet" "prod_subnet" {
  cidr_block        = "10.0.1.0/24"
  vpc_id            = aws_vpc.prod_vpc.id
  availability_zone = "eu-north-1a"

  tags = {
    Name = "prod_subnet"
    "Terraform" = "true"
  }
}

resource "aws_internet_gateway" "prod_gw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "prod_gw"
    "Terraform" = "true"
  }
}

resource "aws_route_table" "prod_rt" {
  vpc_id = aws_vpc.prod_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.prod_gw.id
  }

  tags = {
    Name = "prod_rt"
    "Terraform" = "true"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = aws_subnet.prod_subnet.id
  route_table_id = aws_route_table.prod_rt.id
}


resource "aws_security_group" "prod_sg" {
  name        = "prod_sg"
  description = "Allow ssh over port 22"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "prod_sg_ssh"
    "Terraform" = "true"
  }
}

resource "aws_instance" "prod_instance" {
  ami           = "ami-01450210d4ebb3bab"
  instance_type = "t3.micro"
  key_name      = var.prod_public_key_name

  vpc_security_group_ids = [aws_security_group.prod_sg.id]
  subnet_id              = aws_subnet.prod_subnet.id

  tags = {
    Name      = "prod_instance_ubuntu"
    "Terraform" = "true"
  }
}

resource "aws_eip" "prod_eip" {
  instance = aws_instance.prod_instance.id
  vpc      = true

  tags = {
    Name = "eip_instance_ubuntu"
    "Terraform" = "true"
  }
}
