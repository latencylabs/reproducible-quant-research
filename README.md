# Infrastructure for Reproducible AI/Quant Research

This project provides the infrastructure to create a fully automated, "one-click" environment for quantitative research using Terraform and Docker on AWS.

## Project Goals

-   **Automation:** Create a consistent, repeatable research environment with a single command.
-   **Infrastructure as Code (IaC):** Use Terraform to declaratively define and manage all cloud resources.
-   **Containerization:** Use Docker to package the JupyterLab application and all its dependencies.
-   **Cloud Architecture Best Practices:** Implement a secure and well-designed AWS environment, including proper networking (VPC), security (IAM, Security Groups), and resource management.
-   **Reproducibility:** Ensure the environment is identical every time it is created to support reproducible research.
