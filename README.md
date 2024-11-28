# Infrastructure for Reproducible AI/Quant Research

This project provides the infrastructure to create a fully automated, "one-click" environment for quantitative research using Terraform and Docker on AWS.

## Project Goals

-   **Automation:** Create a consistent, repeatable research environment with a single command.
-   **Infrastructure as Code (IaC):** Use Terraform to declaratively define and manage all cloud resources.
-   **Containerization:** Use Docker to package the JupyterLab application and all its dependencies.
-   **Cloud Architecture Best Practices:** Implement a secure and well-designed AWS environment.
-   **Reproducibility:** Ensure the environment is identical every time it is created to support reproducible research.

## How it Works

This project uses Terraform to provision a set of resources within a dedicated Virtual Private Cloud (VPC) on AWS. The core of the environment is an EC2 instance that automatically pulls and runs a pre-configured JupyterLab Docker container on startup. Data can be stored and accessed from a dedicated S3 bucket.

For a detailed explanation of the system architecture, component design, and technology stack, see the [Architecture Documentation](./docs/architecture.md).

## Usage

The environment is managed via a `Makefile` that provides a simple set of commands.

### 1. Prerequisites

-   An AWS account.
-   [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed locally.
-   [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed locally.
-   [Docker](https://docs.docker.com/engine/install/) installed locally.
-   `make` command available.

### 2. Configure AWS Credentials

Before you can deploy the infrastructure, you must configure AWS credentials for Terraform. Follow the [IAM User Setup Guide](./docs/iam-user-setup.md) to create a dedicated IAM user with the correct permissions and configure your credentials in a local `.env` file.

### 3. Configure SSH Key (Optional but Recommended)

To enable SSH access for debugging, you must have an EC2 Key Pair in your AWS account and its name configured.
- Create a file named `terraform/terraform.tfvars`.
- Add the following line, replacing `my-key` with the name of your key pair:
  ```terraform
  ec2_key_name = "my-key"
  ```
- Place your private key file (e.g., `my-key.pem`) inside the `terraform/` directory.

### 4. Deploy the Environment

```bash
make up
```
This command will provision all the necessary AWS resources. After it completes, it will output the URL for the JupyterLab instance.

### 5. Access JupyterLab

Open the `jupyterlab_url` from the output in your browser. The default authentication token is `a-secure-token-for-dev`.

### 6. Destroy the Environment

When you are finished, destroy all resources to avoid ongoing costs.

**Important:** The S3 bucket will be forcefully destroyed, including any objects it contains.

```bash
make down
```

### Other Commands

-   `make ssh`: SSH into the running EC2 instance. Requires SSH key to be configured.
-   `make output`: Display the Terraform outputs again (e.g., JupyterLab URL, S3 bucket name).
