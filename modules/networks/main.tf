terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}
/*========== The VPC =============*/
 resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block

  tags = {
    Name          = "${var.env_name}-vpc"
  }
}
/*=========== Internet Gateway ============*/
resource "aws_internet_gateway" "Internet-Gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env_name}-Int-Gateway"
  }
}
/*================== Public Subnet 1 =====================*/
resource "aws_subnet" "PublicSubnet1" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.az1}"
  cidr_block              = "${var.public_subnet1_cidr_block}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env_name}-Pub-Sub1"
  }
}
/*================== Public Subnet 2 =====================*/
resource "aws_subnet" "PublicSubnet2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.az2}"
  cidr_block              = "${var.public_subnet2_cidr_block}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env_name}-Pub-Sub2"
  }
}
/*================== Private Subnet 1 =====================*/
resource "aws_subnet" "PrivateSubnet1" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.az1}"
  cidr_block              = "${var.private_subnet1_cidr_block}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.env_name}-Priv-Sub1"
  }
}
/*================== Private Subnet 2 =====================*/
resource "aws_subnet" "PrivateSubnet2" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.az2}"
  cidr_block              = "${var.private_subnet2_cidr_block}"
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env_name}-Priv-Sub2"
  }
}
/*=========================NAT GATEWAY======================*/
resource "aws_eip" "NatGateway1EIP" {
    vpc = true

    depends_on = [
      aws_internet_gateway.Internet-Gateway
    ]
    tags = {
    Name = "${var.env_name}-nat-eip1"
  }
}

resource "aws_eip" "NatGateway2EIP" {
    vpc = true

    depends_on = [
      aws_internet_gateway.Internet-Gateway
    ]
    tags = {
    Name = "${var.env_name}-nat-eip2"
  }
}

resource "aws_nat_gateway" "NatGateway1" {
    allocation_id = aws_eip.NatGateway1EIP.id
    subnet_id     = aws_subnet.PublicSubnet1.id
    tags = {
    Name = "${var.env_name}-nat-gate1"
  }
}

resource "aws_nat_gateway" "NatGateway2" {
    allocation_id = aws_eip.NatGateway2EIP.id
    subnet_id     = aws_subnet.PublicSubnet2.id
    tags = {
    Name = "${var.env_name}-nat-gate2"
  }
}

/*=========================Public ROUTE TABLE ======================*/
resource "aws_route_table" "PublicRouteTable" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      "Name" = "${var.env_name}-pub-rt"
    }
}

resource "aws_route" "DefaultPublicRoute" {
    route_table_id         = aws_route_table.PublicRouteTable.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.Internet-Gateway.id
}

resource "aws_route_table_association" "PublicSubnet1RouteTableAssociation" {
    route_table_id = aws_route_table.PublicRouteTable.id
    subnet_id      = aws_subnet.PublicSubnet1.id
}

resource "aws_route_table_association" "PublicSubnet2RouteTableAssociation" {
    route_table_id = aws_route_table.PublicRouteTable.id
    subnet_id      = aws_subnet.PublicSubnet2.id
}


/*=========================Private ROUTE TABLE ======================*/
resource "aws_route_table" "PrivateRouteTable1" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      "Name" = "${var.env_name}-prv-rt1"
    }
}

resource "aws_route" "DefaultPrivateRoute1" {
    route_table_id         = aws_route_table.PrivateRouteTable1.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.NatGateway1.id
}

resource "aws_route_table_association" "PrivateSubnet1RouteTableAssociation" {
    route_table_id = aws_route_table.PrivateRouteTable1.id
    subnet_id      = aws_subnet.PrivateSubnet1.id
}

resource "aws_route_table" "PrivateRouteTable2" {
    vpc_id = aws_vpc.vpc.id

    tags = {
      "Name" = "${var.env_name}-prv-rt2"
    }
}

resource "aws_route" "DefaultPrivateRoute2" {
    route_table_id         = aws_route_table.PrivateRouteTable2.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id         = aws_nat_gateway.NatGateway2.id
}

resource "aws_route_table_association" "PrivateSubnet2RouteTableAssociation" {
    route_table_id = aws_route_table.PrivateRouteTable2.id
    subnet_id      = aws_subnet.PrivateSubnet2.id
}