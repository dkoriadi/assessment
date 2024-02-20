resource "aws_lb" "alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = [for subnet in aws_subnet.public_subnet : subnet.id]
  security_groups    = [aws_security_group.alb.id]

  tags = {
    Name = "${var.prefix}-alb"
  }
}

resource "aws_lb_target_group" "alb_tg" {
  name     = "${var.prefix}-alb-tg"
  port     = var.http_server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id
}

resource "aws_lb_target_group_attachment" "alb_tg_instance" {
  count = length(aws_instance.web_server)
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.web_server[count.index].id
  port             = var.http_server_port
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.http_server_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

# Security Group
resource "aws_security_group" "alb" {
  name = var.alb_security_group_name

  # Allow inbound HTTP requests
  ingress {
    from_port   = var.http_server_port
    to_port     = var.http_server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}