

resource "aws_instance" "web" {
  ami                    = "ami-02d46314883bdd49c"      #change ami id for different region
  instance_type          = "t2.nano"
  key_name               = "devops_pipeline"              #change key name as per your setup
  vpc_security_group_ids = [aws_security_group.kali_linux_sg.id]

  tags = {
    Name = "kalilinux_aws_ec2"
  }

  root_block_device {
    volume_size = 40
  }
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "terraform_kali_instance_ec2"
  }
}

resource "aws_subnet" "my_subnet_01" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/27"
  availability_zone = "us-east-1a"

  tags = {
    Name = "subnet_kali_01"
  }
}


resource "aws_subnet" "my_subnet_02" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.32/27"
  availability_zone = "us-east-1b"

  tags = {
    Name = "subnet_kali_02"
  }
}


resource "aws_subnet" "my_subnet_03" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.64/27"
  availability_zone = "us-east-1c"

  tags = {
    Name = "subnet_kali_03"
  }
}

resource "aws_security_group" "kali_linux_sg" {
  name        = "kali_linux_sg"
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000, 3389] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-VM-SG"
  }
}
