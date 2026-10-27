variable "environment" {
  description = "Deployment environment."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "company" {
  description = "Company short name used in resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.company))
    error_message = "Company must be lowercase and may contain numbers and hyphens only."
  }
}

variable "project" {
  description = "Project short name used in resource names."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project))
    error_message = "Project name must be lowercase and may contain numbers and hyphens only."
  }
}

variable "aws_region" {
  description = "AWS region."
  type        = string
  default     = "ap-southeast-2"

  validation {
    condition     = contains(["us-east-1", "us-east-2", "ap-southeast-2"], var.aws_region)
    error_message = "Region must be one of: us-east-1, us-east-2, ap-southeast-2."
  }
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}

  validation {
    condition     = contains(keys(var.tags), "Owner")
    error_message = "tags must include an Owner key."
  }

  validation {
    condition     = var.environment != "prod" || (contains(keys(var.tags), "DataClass") && contains(keys(var.tags), "Environment"))
    error_message = "Prod tags must include both DataClass and Environment."
  }
}

variable "enable_versioning" {
  description = "Enable S3 versioning."
  type        = bool
  default     = false

  validation {
    condition     = var.environment == "dev" || var.enable_versioning
    error_message = "Versioning must be enabled in staging and prod."
  }
}

variable "enable_dynamodb" {
  type    = bool
  default = true
}

variable "enable_iam_role" {
  type    = bool
  default = true
}

variable "enable_ssm_parameters" {
  type    = bool
  default = true
}

variable "enable_cloudwatch_logs" {
  type    = bool
  default = true
}

variable "enable_lifecycle_rule" {
  type    = bool
  default = true
}

variable "enable_ec2_test_instance" {
  description = "Optional EC2 test instance. Disabled by default."
  type        = bool
  default     = false

  validation {
    condition     = !(var.environment == "prod" && var.enable_ec2_test_instance)
    error_message = "EC2 test instance must never be enabled in prod."
  }

  validation {
    condition     = !(var.environment == "staging" && var.enable_ec2_test_instance)
    error_message = "EC2 test instance must be disabled in staging."
  }
}

variable "lifecycle_expiration_days" {
  description = "Days after which S3 objects expire."
  type        = number
  default     = 7

  validation {
    condition     = var.lifecycle_expiration_days >= 1 && var.lifecycle_expiration_days <= 365
    error_message = "lifecycle_expiration_days must be between 1 and 365."
  }

  validation {
    condition     = !(var.environment == "prod" && var.lifecycle_expiration_days < 30)
    error_message = "Prod lifecycle_expiration_days must be at least 30."
  }
}

variable "prevent_destroy" {
  description = "Protect stateful resources from destroy (true only in prod)."
  type        = bool
  default     = false

  validation {
    condition     = var.prevent_destroy == (var.environment == "prod")
    error_message = "prevent_destroy must be true in prod and false in dev/staging."
  }
}

variable "ssm_parameters" {
  description = "Map of SSM String parameters (name => value)."
  type        = map(string)
  default     = {}
}

variable "log_groups" {
  description = "Map of CloudWatch log group (name => retention days)."
  type        = map(number)
  default     = {}

  validation {
    condition     = alltrue([for d in values(var.log_groups) : contains([1, 3, 5, 7, 14, 30, 60, 90], d)])
    error_message = "Retention must be one of: 1, 3, 5, 7, 14, 30, 60, 90 days (short, cost-safe)."
  }
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed by the security group."
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for c in var.allowed_cidr_blocks : can(cidrhost(c, 0))])
    error_message = "Every entry must be a valid CIDR block."
  }

  validation {
    condition     = !(var.environment == "prod" && contains(var.allowed_cidr_blocks, "0.0.0.0/0"))
    error_message = "0.0.0.0/0 is not allowed in prod."
  }
}
