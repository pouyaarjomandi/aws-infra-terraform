variable "project_name" {
  description = "Name of the project, used for tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for EKS node groups"
  type        = list(string)
}

variable "eks_cluster_role_arn" {
  description = "ARN of the IAM role for EKS cluster"
  type        = string
}

variable "eks_nodes_role_arn" {
  description = "ARN of the IAM role for EKS node group"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.34"
}

variable "eks_public_access_cidrs" {
  description = "Allowed CIDR blocks for the EKS public API endpoint"
  type        = list(string)
}

variable "eks_control_plane_log_retention_in_days" {
  description = "Retention period in days for EKS control plane logs"
  type        = number
  default     = 30
}

variable "node_instance_types" {
  description = "List of EC2 instance types for EKS node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "node_desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 2
}

variable "node_max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 4
}

variable "node_disk_size" {
  description = "Disk size in GB for each node"
  type        = number
  default     = 20
}
