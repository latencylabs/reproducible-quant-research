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

# IAM Role for the EC2 instance to access S3
resource "aws_iam_role" "jupyter_s3_access" {
  name = "${var.project_name}-s3-access-role"

  # Trust policy allowing EC2 instances to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_name}-s3-access-role"
  }
}

# IAM Policy Document granting read-only access to the S3 bucket
data "aws_iam_policy_document" "s3_read_only" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.data.arn,
      "${aws_s3_bucket.data.arn}/*"
    ]
  }
}

# Attach the policy to the IAM role
resource "aws_iam_role_policy" "s3_read_only" {
  name   = "${var.project_name}-s3-read-only-policy"
  role   = aws_iam_role.jupyter_s3_access.id
  policy = data.aws_iam_policy_document.s3_read_only.json
}

# Instance profile to attach the role to an EC2 instance
resource "aws_iam_instance_profile" "jupyter" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.jupyter_s3_access.name
}
