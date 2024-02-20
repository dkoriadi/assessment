# resource "aws_internet_gateway" "igw" {
#   vpc_id = data.aws_vpc.default.id

#   tags = {
#     Name = "${var.prefix}-igw"
#   }
# }

resource "aws_route_table" "route_table" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }

  tags = {
    Name = "${var.prefix}-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.subnet_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.route_table.id
}