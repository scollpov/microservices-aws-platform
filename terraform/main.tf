#-------------------------
# Provider
#-------------------------
provider "aws" {
  region = "eu-west-1"
}

#-------------------------
# VPC
#-------------------------
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "microservice-vpc"
  }
}

#-------------------------
# Internet Gateway
#-------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "microservice-igw"
  }
}

#-------------------------
# Public Subnet 1
#-------------------------
resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }
}

#-------------------------
# Public Subnet 2
#-------------------------
resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "eu-west-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }
}

#-------------------------
# Private Subnet 1
#-------------------------
resource "aws_subnet" "private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    Name = "private-subnet-1"
  }
}

#-------------------------
# Private Subnet 2
#-------------------------
resource "aws_subnet" "private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "eu-west-1b"

  tags = {
    Name = "private-subnet-1"
  }
}

#-------------------------
# Public Route Table
#-------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}

#-------------------------
# Route to Internet
#-------------------------
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#---------------------------
# Associate Public Subnet 1
#---------------------------
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

#---------------------------
# Associate Public Subnet 2
#---------------------------
resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

#-------------------------
# USER POOL
#-------------------------
resource "aws_cognito_user_pool" "pool" {
  name = "microservices-user-pool"

  #  username_attributes      = ["email"]
  #  auto_verified_attributes = ["email"]
}

#-------------------------
# APP CLIENT
#-------------------------
resource "aws_cognito_user_pool_client" "client" {
  name         = "gateway-client"
  user_pool_id = aws_cognito_user_pool.pool.id

  generate_secret = false

  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_flows = ["code"]

  allowed_oauth_scopes = [
    "openid",
    "email",
    "profile"
  ]

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH"
  ]

  callback_urls = [
    "http://localhost:8080/callback"
  ]

  #  logout_urls = [
  #   "http://localhost:8080"
  #  ]

  supported_identity_providers = ["COGNITO"]
}

#-------------------------
# DOMAIN
#-------------------------
resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "gateway-auth-123456" # 
  user_pool_id = aws_cognito_user_pool.pool.id
}
