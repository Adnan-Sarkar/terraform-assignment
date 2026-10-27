.PHONY: init fmt validate plan-dev apply-dev plan-staging plan-prod destroy-dev

init:
	terraform init

fmt:
	terraform fmt -recursive

validate:
	terraform validate

plan-dev:
	terraform plan -var-file=envs/dev.tfvars -out=dev.tfplan

apply-dev:
	terraform apply "dev.tfplan"

plan-staging:
	terraform plan -var-file=envs/staging.tfvars -out=staging.tfplan

plan-prod:
	terraform plan -var-file=envs/prod.tfvars -out=prod.tfplan

destroy-dev:
	terraform destroy -var-file=envs/dev.tfvars