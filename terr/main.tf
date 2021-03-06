
provider "aws" {
   access_key = "${var.access_key}"
   secret_key = "${var.secret_key}"
   region = "${var.region}"
}
#-----------------------------------------------------------
resource "aws_instance" "test_server" {
        ami = "${var.ami}"
        instance_type = "${var.instance_type}"
        subnet_id = "${var.subnet_id}"
        vpc_security_group_ids = [aws_security_group.sg.id]
	      key_name = "${var.key_name}"
        tags = {
        Name = "Test"
        }

}
#-----------------------------------------------------------
resource "aws_vpc" "my_VPC" {
  cidr_block           = var.vpcCIDRblock
  tags = {
    Name = "${var.projectName}_vpc"
  }
}
#-----------------------------------------------------------
resource "aws_subnet" "my_VPC_Subnet" {
  vpc_id                  = aws_vpc.my_VPC.id
  cidr_block              = var.subnetCIDRblock
  tags = {
    Name = "${var.projectName}_subnet"
  }
}
#-----------------------------------------------------------
resource "aws_security_group" "sg" {
          name        = "${var.projectName}_SG"
          vpc_id = aws_vpc.my_VPC.id

  dynamic "ingress"{
      for_each = ["22", "80", "443"]
      content {
              from_port = ingress.value
              to_port = ingress.value
              protocol = "tcp"
              cidr_blocks = [var.CIDRblock]
           }
          }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.CIDRblock]
  }
}
#-----------------------------------------------------------
resource "aws_internet_gateway" "my_VPC_GW" {
 vpc_id = aws_vpc.my_VPC.id
 tags = {
        Name = "${var.projectName}_GW"
}
}
#-----------------------------------------------------------
resource "aws_route_table" "my_VPC_route_table" {
 vpc_id = aws_vpc.my_VPC.id
 tags = {
        Name = "${var.projectName}_route_table"
}
}
#-----------------------------------------------------------
resource "aws_route" "My_VPC_internet_access" {
  route_table_id         = aws_route_table.my_VPC_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.my_VPC_GW.id
}
#-----------------------------------------------------------
resource "aws_route_table_association" "My_VPC_association" {
  subnet_id      = aws_subnet.my_VPC_Subnet.id
  route_table_id = aws_route_table.my_VPC_route_table.id
}
#-----------------------------------------------------------
output "public_ip_address_test" {
  value = aws_instance.test_server.public_ip
}