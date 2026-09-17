resource "aws_vpc" "this" {
  #checkov:skip=CKV2_AWS_11:VPC Flow Logs are intentionally not enabled for this lab environment.
  #checkov:skip=CKV2_AWS_12:Default VPC security group restriction is intentionally not enforced for this lab baseline.
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${trimsuffix(var.name, "-vpc")}-igw"
    }
  )
}

resource "aws_subnet" "public" {
  #checkov:skip=CKV_AWS_130:Public IP assignment is intentional because these are explicitly designed public subnets for the lab.
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${trimsuffix(var.name, "-vpc")}-public-subnet-${substr(var.availability_zones[count.index], -2, 2)}"
      Tier = "public"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.tags,
    {
      Name = "${trimsuffix(var.name, "-vpc")}-private-subnet-${substr(var.availability_zones[count.index], -2, 2)}"
      Tier = "private"
    }
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${trimsuffix(var.name, "-vpc")}-public-rt"
      Tier = "public"
    }
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(
    var.tags,
    {
      Name = "${trimsuffix(var.name, "-vpc")}-private-rt"
      Tier = "private"
    }
  )
}

resource "aws_route_table_association" "private" {
  count = length(var.availability_zones)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
