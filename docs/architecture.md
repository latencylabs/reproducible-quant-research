# Architecture and Design

This document details the system architecture and technology choices for the project.

## 1. System Overview

The system uses Terraform to provision a set of resources within a dedicated Virtual Private Cloud (VPC) on AWS. A user on their local machine runs a `make` command, which invokes Terraform to build or destroy the cloud environment. The core of the environment is an EC2 instance that automatically pulls and runs a pre-configured JupyterLab Docker container on startup.

**Deployment Flow:**
`User's Machine (make up)` -> `Terraform` -> `AWS API` -> `(VPC, EC2, S3, IAM Role)`

**Data Access Flow (within a notebook):**
`Jupyter Notebook (Python)` -> `boto3 AWS SDK` -> `EC2 Instance IAM Role` -> `S3 Bucket`

## 2. Component Design

### Terraform Configuration (`terraform/`)

The Infrastructure as Code (IaC) is structured into logical, modular files for clarity and reusability.
-   `main.tf`: Defines the AWS provider and orchestrates the module calls.
-   `variables.tf`: Contains input variables like region, instance type, and project name.
-   `outputs.tf`: Declares outputs like the EC2 instance's public IP and the JupyterLab URL.
-   `network.tf`: Defines the VPC, subnet, internet gateway, and route table.
-   `compute.tf`: Defines the EC2 instance, including its AMI and `user_data` script.
-   `security.tf`: Defines the Security Group and IAM roles/policies.
-   `storage.tf`: Defines the S3 bucket for datasets.

### Docker Image (`src/Dockerfile`)

-   **Base Image:** `python:3.10-slim` to keep the image size small.
-   **Dependencies:** Installs necessary Python libraries via `pip` from `src/requirements.txt` (e.g., `jupyterlab`, `pandas`, `boto3`, `scikit-learn`).
-   **Configuration:** Configures JupyterLab to be accessible from any IP address (`--ip=0.0.0.0`) and exposes the default port `8888`.
-   **Workspace:** Copies the `src/sample-analysis.ipynb` notebook into the container's workspace.

### EC2 Instance Automation (`scripts/user_data.sh.tpl`)

A shell script passed to the EC2 instance to run on its first boot. It performs the following actions:
1.  Updates the package manager.
2.  Installs Docker.
3.  Starts the Docker service.
4.  Pulls the specified JupyterLab Docker image from a public registry (e.g., Docker Hub).
5.  Runs the Docker container, mapping port `80` on the host to port `8888` in the container for easy browser access, and injects the authentication token.

### Security Model

-   **Network Security:** A Security Group is used to control traffic to the EC2 instance.
    -   **Ingress (Inbound):** Allows SSH (port 22) and HTTP (port 80) traffic **only** from the user's current public IP address. This IP is determined automatically using an external data source in Terraform.
    -   **Egress (Outbound):** Allows all outbound traffic so the instance can download packages and container images.
-   **IAM (Identity and Access Management):** An IAM role is attached to the EC2 instance.
    -   **Permissions:** The role grants the EC2 instance **read-only access** to the specific S3 bucket created by Terraform.
    -   **Benefit:** This avoids the need to store any AWS access keys or secrets on the instance itself. The AWS SDK (boto3) used in the Jupyter notebook will automatically discover and use these permissions.

## 3. Technology Stack

-   **Infrastructure as Code:** Terraform
-   **Containerization:** Docker
-   **Cloud Provider:** Amazon Web Services (AWS)
    -   **Compute:** EC2
    -   **Storage:** S3
    -   **Networking:** VPC
    -   **Security:** IAM, Security Groups
-   **Automation/CLI:** GNU Make
-   **Core Application:** JupyterLab
