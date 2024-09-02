IS_TERRAFORM_PRESENT := $(shell command -v terraform 2> /dev/null)
IS_TERRAGRUNT_PRESENT := $(shell command -v terragrunt 2> /dev/null)

AWS_ACCESS_KEY_ID ?=
AWS_SECRET_ACCESS_KEY ?=
AWS_DEFAULT_REGION ?= us-east-2

.PHONY: help
help:
	@echo "Available targets:"
	@echo "          plan: runs terragrunt plan"
	@echo "         apply: runs terragrunt apply"
	@echo "       destroy: runs terragrunt destroy"
	@echo " fetch_secrets: runs the bash script that retrives all the secrets"
	@echo

.PHONY: check_tf_basics
check_tf_basics:
ifndef IS_TERRAFORM_PRESENT
	$(error terraform is not available. Install it: https://developer.hashicorp.com/terraform/install)
endif
ifndef IS_TERRAGRUNT_PRESENT
	$(error terragrunt is not present. Install it: https://terragrunt.gruntwork.io/docs/getting-started/install/)
endif

.PHONY:
check_env_vars:
ifndef AWS_ACCESS_KEY_ID
	$(error AWS_ACCESS_KEY_ID must be set)
endif
ifndef AWS_SECRET_ACCESS_KEY
	$(error AWS_SECRET_ACCESS_KEY must be set)
endif
ifndef AWS_DEFAULT_REGION
	$(error AWS_DEFAULT_REGION must be set)
endif

.PHONY: plan
plan: check_tf_basics check_env_vars
	# Planning the environment...
	@(cd terraform; \
	  terragrunt plan)
	# Done.

.PHONY: apply
apply: check_tf_basics check_env_vars
	# Creating/Updating the environment...
	@(cd terraform; \
	  terragrunt apply)
	# Done.

.PHONY: destroy
destroy: check_tf_basics check_env_vars
	# Destroying the environment...
	@(cd terraform; \
	  terragrunt destroy)
	# Done.

.PHONY: fetch_secrets
fetch_secrets: check_env_vars
	@(cd scripts; \
	  bash 1.sh)
