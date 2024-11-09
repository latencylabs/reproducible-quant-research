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
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro" # Free-tier eligible (NFR-4)
  key_name               = var.ec2_key_name
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.jupyter.id]
  iam_instance_profile   = aws_iam_instance_profile.jupyter.name

  # user_data script to install Docker and run the container on boot
  user_data = templatefile("${path.module}/../scripts/user_data.sh.tpl", {
    docker_image_name = var.docker_image_name,
    jupyter_token     = var.jupyter_token
  })

  tags = {
    Name = "${var.project_name}-instance"
  }
}
