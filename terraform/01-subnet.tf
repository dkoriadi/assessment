# resource "aws_vpc" "main" {
#   cidr_block = var.vpc_cidr

#   tags = {
#     name = "${var.prefix}-vpc-${var.region}"
#   }
# }

resource "aws_subnet" "public_subnet" {
  count             = length(var.subnet_cidr)
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = var.subnet_cidr[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    "Name" = "${var.prefix}-subnet-${count.index + 1}"
  }
}