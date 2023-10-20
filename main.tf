resource "aws_vpc" "vpc-demo" {
  cidr_block       = "10.0.0.0/18"
  instance_tenancy = "default"
  tags = {
    name = "vpc-demo"
  }
}

resource "aws_security_group" "allow_HTTP" {
  name        = "allow_HTTP"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.vpc-demo.id


  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc-demo.cidr_block]
  }
   ingress {
    description = "Allow HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc-demo.cidr_block]
  }
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc-demo.cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "Allow All Traffic"
  }
}

resource "aws_subnet" "subnet-demo" {
  vpc_id                  = aws_vpc.vpc-demo.id
  cidr_block              = "10.0.0.0/21"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true
  tags = {
    name = "subnet-demo-public1"
  }
}
resource "aws_subnet" "subnet-demo1" {
  vpc_id                  = aws_vpc.vpc-demo.id
  cidr_block              = "10.0.8.0/21"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true
  tags = {
    name = "subnet-demo-public2"
  }
}


resource "aws_subnet" "subnet-demo3" {
  vpc_id                  = aws_vpc.vpc-demo.id
  cidr_block              = "10.0.16.0/21"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false
  tags = {
    name = "subnet-demo-private1"
  }
}
resource "aws_subnet" "subnet-demo4" {
  vpc_id                  = aws_vpc.vpc-demo.id
  cidr_block              = "10.0.24.0/21"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false
  tags = {
    name = "subnet-demo-private2"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.vpc-demo.id
  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo-RT" {
  vpc_id = aws_vpc.vpc-demo.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
  tags = {
    Name = "demo-RT"
  }
}

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.subnet-demo.id
  route_table_id = aws_route_table.demo-RT.id
}
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.subnet-demo1.id
  route_table_id = aws_route_table.demo-RT.id
}
