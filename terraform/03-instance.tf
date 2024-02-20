resource "aws_instance" "web_server" {
  count                       = 2
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.web_server.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public_subnet[count.index].id
  availability_zone           = var.availability_zones[count.index]
  vpc_security_group_ids      = [aws_security_group.instance.id]

  tags = {
    Name = "${var.prefix}-instance-${count.index + 1}"
    Owner = "David"
    Project = "DevOpsTest"
  }

  volume_tags = {
    Name = "${var.prefix}-instance-${count.index + 1}"
    Owner = "David"
    Project = "DevOpsTest"
  }
}

resource "null_resource" "configure_web_app" {
  count = length(aws_instance.web_server)
  depends_on = [aws_eip_association.web_server_public_ip]

  triggers = {
    build_number = timestamp()
  }

  provisioner "file" {
    source      = "files/"
    destination = "/home/ubuntu/"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.web_server.private_key_pem
      host        = aws_eip.web_server_public_ip[count.index].public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt -y update",
      "sleep 15",
      "sudo apt -y update",
      "sudo apt -y install nginx",
      "sudo systemctl start nginx",
      "sudo chown -R ubuntu:ubuntu /var/www/html",
      "chmod +x *.sh",
      "./userdata.sh",
      "sudo cp nginx.conf /etc/nginx/nginx.conf",
      "sudo systemctl restart nginx",
      "sudo apt -y install python3-pip",
      "pip install flask",
      "nohup python3 app.py &",
      "sleep 15"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = tls_private_key.web_server.private_key_pem
      host        = aws_eip.web_server_public_ip[count.index].public_ip
    }
  }
}

# Security Group
resource "aws_security_group" "instance" {
  name = var.instance_security_group_name

  vpc_id = data.aws_vpc.default.id

  # Allow inbound HTTP requests and SSH
  ingress {
    from_port   = var.http_server_port
    to_port     = var.http_server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
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

  tags = {
    Name = "${var.prefix}-sg-instance"
  }
}

# SSH Key Pair
resource "tls_private_key" "web_server" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "web_server" {
  key_name   = local.private_key_filename
  public_key = tls_private_key.web_server.public_key_openssh
}

# Public IP / Elastic IP
resource "aws_eip" "web_server_public_ip" {
  count = length(aws_instance.web_server)
  instance = aws_instance.web_server[count.index].id
  domain   = "vpc"
}

resource "aws_eip_association" "web_server_public_ip" {
  count = length(aws_instance.web_server)
  instance_id   = aws_instance.web_server[count.index].id
  allocation_id = aws_eip.web_server_public_ip[count.index].id
}