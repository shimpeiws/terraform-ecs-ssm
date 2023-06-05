resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform-ecs-ssm-${var.env_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw-terraform-ecs-ssm-${var.env_name}"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-route-table-terraform-ecs-ssm-${var.env_name}"
  }
}

resource "aws_subnet" "public-0" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "subnet-public-1a"
  }
}

resource "aws_route_table_association" "public-association" {
  subnet_id = aws_subnet.public-0.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_subnet" "private-0" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.65.0/24"
  availability_zone       = "ap-northeast-1a"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private-1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.66.0/24"
  availability_zone       = "ap-northeast-1c"
  map_public_ip_on_launch = false
}

resource "aws_security_group" "security-group" {
  name        = "security-group-${var.env_name}"
  vpc_id      = aws_vpc.vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_iam_policy_document" "vpc_endpoint" {
  statement {
    effect    = "Allow"
    actions   = [ "*" ]
    resources = [ "*" ]
    principals {
      type = "AWS"
      identifiers = [ "*" ]
    }
  }
}

resource "aws_security_group" "ssm" {
  name        = "terraform-ecs-ssm-dev-ssm-sg"
  description = "terraform-ecs-ssm-dev-ssm-sg"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol  = "tcp"
    cidr_blocks = [
      "10.0.0.0/16"
    ]
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.ssm"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    aws_subnet.private-0.id
  ]
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id
  ]
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_endpoint_type = "Interface"
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.ssmmessages"
  policy            = data.aws_iam_policy_document.vpc_endpoint.json
  subnet_ids = [
    aws_subnet.private-0.id
  ]
  private_dns_enabled = true
  security_group_ids = [
    aws_security_group.ssm.id
  ]
}
