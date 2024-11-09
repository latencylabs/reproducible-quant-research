output "jupyter_instance_public_ip" {
  description = "The public IP address of the JupyterLab EC2 instance."
  value       = aws_instance.jupyter.public_ip
}

output "jupyterlab_url" {
  description = "The URL to access the JupyterLab interface."
  value       = "http://${aws_instance.jupyter.public_ip}"
}

output "s3_data_bucket_name" {
  description = "The name of the S3 bucket for storing datasets."
  value       = aws_s3_bucket.data.id
}
