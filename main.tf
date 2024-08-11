provider "aws"{
    region = "us-east-1"
}

resource "aws_vpc" "one"{
    cidr_block="10.0.0.0/16"
    tegs={
        Name="my_vpc"
    }
}

resource "aws_security_group" "sg"{
    ingress=[
        {
            cidr_block=["0.0.0.0"]
            protocol="tcp"
        }
    ]
     egress=[{
        cidr_block=["0.0.0.0"]
        protocol="-1"
     }]
}
 
resource "aws_subnet" "private"{
    vpc_id=aws_vpc.one.id
    cidr_block="10.0.0.15/16"
    availability_zone="us-east-1a"
    tags={
        Name="private-subnet"
    }

}

resource "aws_subnet" "public"{
    vpc_id=aws_vpc.one.id
    cidr_block="10.0.0.16/16"
    availability_zone="us-east-1a"
    tags={
        Name="private-subnet"
    }

}
 
resource "aws_instance" "two"{
    subnet_id=aws_subnet.public-subnet.public
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
