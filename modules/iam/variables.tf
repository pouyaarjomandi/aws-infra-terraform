variable "project_name" {
  description = "Name of the project, used for tagging and naming roles"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}