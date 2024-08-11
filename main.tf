terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.37.0"
    }
  }
}

provider "aws"{
    region = "us-east-1"
}

resource "aws_vpc" "one"{
    cidr_block="10.0.0.0/16"
    tags={
        Name="my_vpc"
    }
}

resource "aws_security_group" "sg" {
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

 
resource "aws_subnet" "private"{
    vpc_id=aws_vpc.one.id
    cidr_block="10.0.0.0/16"
    availability_zone="us-east-1a"
    tags={
        Name="private-subnet"
    }

}

resource "aws_subnet" "public"{
    vpc_id=aws_vpc.one.id
    cidr_block="10.0.0.0/16"
    availability_zone="us-east-1a"
    tags={
        Name="private-subnet"
    }

}
 
resource "aws_instance" "two"{
    subnet_id=aws_subnet.public.id
    ami="ami-0ae8f15ae66fe8cda"
    instance_type="t2.micro"
    key_name="linux_1"
    vpc_security_group_ids=[aws_security_group.sg.id]
    tags={
        Name="web-server"
    }
}
output "three"{
    value=[aws_instance.two.public_ip]
}
