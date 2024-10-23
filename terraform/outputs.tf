output "jupyter_instance_public_ip" {
  description = "The public IP address of the JupyterLab EC2 instance."
  value       = aws_instance.jupyter.public_ip
}
