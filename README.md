# Infrastructure for Reproducible AI/Quant Research

This project provides the infrastructure to create a fully automated, "one-click" environment for quantitative research using Terraform and Docker on AWS.

## Project Goals

-   **Automation:** Create a consistent, repeatable research environment with a single command.
-   **Infrastructure as Code (IaC):** Use Terraform to declaratively define and manage all cloud resources.
-   **Containerization:** Use Docker to package the JupyterLab application and all its dependencies.
-   **Cloud Architecture Best Practices:** Implement a secure and well-designed AWS environment, including proper networking (VPC), security (IAM, Security Groups), and resource management.
-   **Reproducibility:** Ensure the environment is identical every time it is created to support reproducible research.

## Usage

The environment is managed via a `Makefile` that provides a simple set of commands.

1.  **Configure AWS Credentials:**
    Follow the [IAM User Setup Guide](./dev-docs/iam-user-setup.md) to create a dedicated IAM user and configure your credentials in a local `.env` file.

2.  **Configure SSH Key (Optional but Recommended):**
    To enable SSH access for debugging, you must have an EC2 Key Pair in your AWS account and its name configured.
    - Create a file named `terraform/terraform.tfvars`.
    - Add the following line, replacing `my-key` with the name of your key pair:
      ```
      ec2_key_name = "my-key"
      ```
    - Place your private key file (e.g., `my-key.pem`) inside the `terraform/` directory.

3.  **Deploy the Environment:**
    ```bash
    make up
    ```
    This command will provision all the necessary AWS resources. After it completes, it will output the URL for the JupyterLab instance.

4.  **Access JupyterLab:**
    Open the `jupyterlab_url` from the output in your browser.

5.  **Destroy the Environment:**
    When you are finished, destroy all resources to avoid ongoing costs.

    **Important:** If you have uploaded files to the S3 bucket, you must empty it before running `make down`.
    1.  Get the S3 bucket name: `make output`
    2.  Empty the bucket using the AWS CLI (replace `<bucket-name>` with your bucket's name):
        ```bash
        aws s3 rm s3://<bucket-name>/ --recursive
        ```
    3.  Destroy the environment:
        ```bash
        make down
        ```

### Other Commands

-   `make ssh`: SSH into the running EC2 instance.
-   `make output`: Display the Terraform outputs again.
