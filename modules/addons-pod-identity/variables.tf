variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_arn" {
  description = "ARN of the EKS cluster"
  type        = string
}
