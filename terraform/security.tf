data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

# Security group to control access to the EC2 instance
resource "aws_security_group" "jupyter" {
  name        = "${var.project_name}-sg"
  description = "Allow SSH and HTTP access for JupyterLab"
  vpc_id      = aws_vpc.main.id

  # Allow inbound SSH access from the user's current IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.my_ip.response_body}/32"]
    description = "Allow SSH from my IP"
  }

  # Allow inbound HTTP access from the user's current IP
  # This will be for accessing JupyterLab on port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${data.http.my_ip.response_body}/32"]
    description = "Allow HTTP from my IP for JupyterLab"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}
