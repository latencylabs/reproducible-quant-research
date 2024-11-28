# IAM User Setup for Terraform

This guide explains how to create a dedicated AWS IAM user with the necessary permissions for Terraform to manage the resources for this project.

## 1. Why a Dedicated User?

Using a dedicated IAM user with scoped-down permissions is a security best practice known as the **principle of least privilege**. Instead of using a root user or an administrator with wide-ranging permissions, this user will only be granted the permissions required to create, modify, and destroy the specific AWS resources defined in this project (VPCs, EC2 instances, S3 buckets, etc.). This minimizes the risk of accidental or malicious damage to other infrastructure in your AWS account.

## 2. Procedure

The recommended way to set up the user is through the AWS Management Console.

### Step 1: Create an IAM Policy

First, create a new customer-managed IAM policy that contains all the permissions Terraform needs.

1.  Navigate to the **IAM** service in the AWS Console.
2.  Go to **Policies** and click **Create policy**.
3.  Switch to the **JSON** tab and paste the following policy document. This policy grants the permissions required to manage the project's resources.

    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowTerraformToManageProjectResources",
                "Effect": "Allow",
                "Action": [
                    "ec2:Describe*",
                    "ec2:CreateVpc", "ec2:DeleteVpc", "ec2:ModifyVpcAttribute",
                    "ec2:CreateSubnet", "ec2:DeleteSubnet", "ec2:ModifySubnetAttribute",
                    "ec2:CreateInternetGateway", "ec2:DeleteInternetGateway", "ec2:AttachInternetGateway", "ec2:DetachInternetGateway",
                    "ec2:CreateRouteTable", "ec2:DeleteRouteTable", "ec2:CreateRoute", "ec2:DeleteRoute", "ec2:AssociateRouteTable", "ec2:DisassociateRouteTable",
                    "ec2:CreateTags", "ec2:DeleteTags",
                    "ec2:RunInstances", "ec2:TerminateInstances", "ec2:StopInstances", "ec2:StartInstances", "ec2:ModifyInstanceAttribute",
                    "ec2:AssociateIamInstanceProfile", "ec2:DisassociateIamInstanceProfile",
                    "ec2:CreateSecurityGroup", "ec2:DeleteSecurityGroup", "ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress", "ec2:AuthorizeSecurityGroupEgress", "ec2:RevokeSecurityGroupEgress",
                    "ec2:CreateKeyPair",
                    "s3:CreateBucket", "s3:DeleteBucket", "s3:List*", "s3:Get*", "s3:Put*", "s3:Delete*",
                    "iam:CreateRole", "iam:DeleteRole", "iam:GetRole", "iam:TagRole",
                    "iam:PutRolePolicy", "iam:DeleteRolePolicy", "iam:GetRolePolicy", "iam:ListRolePolicies", "iam:ListAttachedRolePolicies", "iam:ListInstanceProfilesForRole",
                    "iam:CreateInstanceProfile", "iam:DeleteInstanceProfile", "iam:GetInstanceProfile", "iam:ListInstanceProfiles",
                    "iam:AddRoleToInstanceProfile", "iam:RemoveRoleFromInstanceProfile",
                    "iam:PassRole"
                ],
                "Resource": "*"
            },
            {
                "Sid": "AllowTerraformToReadDataSources",
                "Effect": "Allow",
                "Action": [
                    "iam:GetUser"
                ],
                "Resource": "*"
            }
        ]
    }
    ```
4.  Click **Next**, give the policy a name (e.g., `repro-quant-research-terraform-policy`), and click **Create policy**.

### Step 2: Create an IAM User and Attach the Policy

Next, create the user that will use this policy.

1.  In the IAM service, go to **Users** and click **Create user**.
2.  Enter a **User name** (e.g., `repro-quant-research-terraform-user`).
3.  Click **Next**.
4.  Select **Attach policies directly**, then search for and select the policy you created in the previous step (e.g., `repro-quant-research-terraform-policy`).
5.  Click **Next**, review the details, and click **Create user**.

### Step 3: Create an Access Key

Now, generate an access key for the user so Terraform can authenticate.

1.  From the user list, click on the user you just created.
2.  Go to the **Security credentials** tab.
3.  In the **Access keys** section, click **Create access key**.
4.  Select **Command Line Interface (CLI)** as the use case.
5.  Acknowledge the recommendation and click **Next**.
6.  Click **Create access key**.
7.  **Important:** This is your only opportunity to see the secret access key. Copy both the **Access key ID** and the **Secret access key** and save them in a secure location.

### Step 4: Create a Local Environment File

To provide the credentials to Terraform, create a file named `.env` in the root of this project directory. This file is listed in `.gitignore` and **must not** be committed to version control.

Add the credentials from the previous step to the `.env` file. **Do not add quotes around the values.**

**File: `.env`**
```
AWS_ACCESS_KEY_ID=<paste your access_key_id here>
AWS_SECRET_ACCESS_KEY=<paste your secret_access_key here>
AWS_DEFAULT_REGION=us-east-1
```

If you are using the VS Code Dev Container, rebuild it for the changes to take effect. The dev container is configured to automatically load these variables, and Terraform inside the container will use them for authentication.
