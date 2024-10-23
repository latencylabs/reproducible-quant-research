# Find the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create the EC2 instance for running JupyterLab
resource "aws_instance" "jupyter" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro" # Free-tier eligible (NFR-4)
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.jupyter.id]

  # user_data will be added later to install Docker and run the container

  tags = {
    Name = "${var.project_name}-instance"
  }
}
