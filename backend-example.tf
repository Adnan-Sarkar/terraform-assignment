# (EXAMPLE ONLY - intentionally commented out for assignment)
#
# terraform {
#   backend "s3" {
#     bucket       = "bjit-adnan-tf-assignment-tfstate"
#     key          = "dev/terraform.tfstate"
#     region       = "ap-southeast-2"
#     encrypt      = true
#     use_lockfile = true
#   }
# }
#
# DESIGN NOTES:
# 1. Variables cannot be used in backend blocks. For multi-environment, we would 
#    use partial backend configs (`terraform init -backend-config=dev.hcl`).
# 2. Native S3 locking (`use_lockfile = true`) removes the need for DynamoDB tables.
# 3. For this assignment, remote state is documented but NOT implemented (bucket must exist before init) and 
#    to keep the execution environment simple and cost-free.
