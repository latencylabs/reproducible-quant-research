.PHONY: all up down output ssh clean help

# Define variables
TF_DIR := terraform

# Default target
all: help

## --------------------------------------
## Environment Lifecycle
## --------------------------------------

up: ## Create and start the research environment
	@echo "Initializing Terraform..."
	@terraform -chdir=$(TF_DIR) init
	@echo "Applying Terraform configuration..."
	@terraform -chdir=$(TF_DIR) apply -auto-approve
	@echo "\nEnvironment is ready. Outputs:"
	@terraform -chdir=$(TF_DIR) output

down: ## Destroy the research environment
	@echo "Destroying Terraform-managed infrastructure..."
	@terraform -chdir=$(TF_DIR) destroy -auto-approve

## --------------------------------------
## Utilities
## --------------------------------------

output: ## Display Terraform outputs
	@terraform -chdir=$(TF_DIR) output

ssh: ## SSH into the EC2 instance
	@IP=$$(terraform -chdir=$(TF_DIR) output -raw jupyter_instance_public_ip); \
	KEY_NAME=$$(terraform -chdir=$(TF_DIR) output -raw ec2_key_name); \
	if [ -z "$${KEY_NAME}" ] || [ "$${KEY_NAME}" = "null" ]; then \
		echo "Error: 'ec2_key_name' is not set in your Terraform variables."; \
		echo "Please define it in terraform/terraform.tfvars and run 'make up' again."; \
		exit 1; \
	fi; \
	KEY_FILE="$(TF_DIR)/$${KEY_NAME}.pem"; \
	if [ ! -f "$${KEY_FILE}" ]; then \
		echo "Error: Key file '$${KEY_FILE}' not found."; \
		echo "Please ensure your private key is in the 'terraform/' directory and named correctly."; \
		exit 1; \
	fi; \
	echo "Connecting to ec2-user@$${IP} using key $${KEY_FILE}..."; \
	ssh -i "$${KEY_FILE}" ec2-user@$${IP}

clean: ## Remove Terraform state and cache files
	@echo "Cleaning up Terraform files..."
	@rm -rf $(TF_DIR)/.terraform
	@rm -f $(TF_DIR)/.terraform.lock.hcl

help: ## Display this help screen
	@echo "Usage: make <command>"
	@echo ""
	@echo "Available commands:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
