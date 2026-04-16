# ──────────────────────────────────────────────
# General
# ──────────────────────────────────────────────
variable "project_name" {
  description = "Name of the project, used for naming and tagging all resources"
  type        = string
  default     = "myapp"
}

variable "environment" {
  description = "Environment name (dev, staging, prod). Defaults to the active Terraform workspace name."
  type        = string
  default     = ""
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# ──────────────────────────────────────────────
# VPC
# ──────────────────────────────────────────────
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# ──────────────────────────────────────────────
# EKS
# ──────────────────────────────────────────────
variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.34"
}

variable "eks_public_access_cidrs" {
  description = "Allowed CIDR blocks for the EKS public API endpoint. Set this explicitly to your current public IP range, for example [\"203.0.113.10/32\"]."
  type        = list(string)
}

variable "eks_control_plane_log_retention_in_days" {
  description = "Retention period in days for EKS control plane logs stored in CloudWatch Logs"
  type        = number
  default     = 30
}

variable "kube_prometheus_stack_chart_version" {
  description = "Pinned kube-prometheus-stack chart version for controlled upgrades"
  type        = string
  default     = "83.4.0"
}

variable "node_instance_types" {
  description = "EC2 instance types for the EKS managed node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 4
}

# ──────────────────────────────────────────────
# Monitoring and access secrets
# ──────────────────────────────────────────────
variable "grafana_admin_password" {
  description = "Optional Grafana admin password override. If null, Terraform generates one."
  type        = string
  sensitive   = true
  nullable    = true
  default     = null
}

variable "alerting_slack_webhook_url" {
  description = "Optional Slack webhook URL for Alertmanager notifications. If null, Slack routing is disabled."
  type        = string
  sensitive   = true
  nullable    = true
  default     = null
}

variable "alerting_slack_channel" {
  description = "Slack channel for non-critical alerts when Slack routing is enabled"
  type        = string
  default     = "#monitoring-alerts"
}

variable "alerting_slack_critical_channel" {
  description = "Slack channel for critical alerts when Slack routing is enabled"
  type        = string
  default     = "#critical-alerts"
}

# ──────────────────────────────────────────────
# RDS
# ──────────────────────────────────────────────
variable "db_name" {
  description = "Name of the database"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Optional master password for the database. If null, Terraform generates one."
  type        = string
  sensitive   = true
  nullable    = true
  default     = null
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.medium"
}

variable "db_engine_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "16.13"
}

variable "multi_az" {
  description = "Enable Multi-AZ for RDS"
  type        = bool
  default     = true
}
