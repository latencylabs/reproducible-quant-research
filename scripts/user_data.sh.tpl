#!/bin/bash
# EC2 User Data script for JupyterLab instance

# Update the instance
yum update -y

# Install and start Docker
amazon-linux-extras install docker -y
service docker start
usermod -a -G docker ec2-user

# Pull the latest version of the specified JupyterLab container image to ensure it's up-to-date
docker pull ${docker_image_name}

# Run the specified JupyterLab container
# Port 80 on the host is mapped to port 8888 in the container
docker run -d -p 80:8888 --name jupyterlab ${docker_image_name} jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --NotebookApp.token='${jupyter_token}'
