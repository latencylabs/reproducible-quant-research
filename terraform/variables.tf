variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "The name of the project, used for tagging resources."
  type        = string
  default     = "repro-quant-research"
}

variable "docker_image_name" {
  description = "The public Docker Hub image to deploy for JupyterLab."
  type        = string
  default     = "latencylabs/reproducible-quant-research:latest"
}

variable "ec2_key_name" {
  description = "The name of an EC2 key pair to associate with the instance for SSH access. The key pair must already exist in the target AWS region."
  type        = string
  default     = null # No key pair is associated by default.
}

variable "jupyter_token" {
  description = "The predefined token to use for JupyterLab authentication."
  type        = string
  default     = "a-secure-token-for-dev"
  sensitive   = true
}
