# ──────────────────────────────────────────────
# VPC
# ──────────────────────────────────────────────
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

# ──────────────────────────────────────────────
# Networking
# ──────────────────────────────────────────────
output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways, one per Availability Zone"
  value       = module.vpc.nat_gateway_ids
}

# ──────────────────────────────────────────────
# EKS
# ──────────────────────────────────────────────
output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "Endpoint of the EKS cluster API server"
  value       = module.eks.cluster_endpoint
}

output "eks_cluster_primary_security_group_id" {
  description = "Primary security group created by Amazon EKS and used as the runtime boundary for managed node groups"
  value       = module.eks.cluster_primary_security_group_id
}

output "eks_control_plane_log_group_name" {
  description = "CloudWatch Logs log group name for EKS control plane logs"
  value       = module.eks.control_plane_log_group_name
}

output "eks_kubectl_config" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}

# ──────────────────────────────────────────────
# Security Groups (needed for Kubernetes manifests)
# ──────────────────────────────────────────────
output "alb_security_group_id" {
  description = "ALB security group ID — use this in Ingress annotations"
  value       = module.security_groups.alb_sg_id
}

# ──────────────────────────────────────────────
# RDS
# ──────────────────────────────────────────────
output "rds_endpoint" {
  description = "Connection endpoint of the RDS instance"
  value       = module.rds.db_endpoint
}

output "rds_db_name" {
  description = "Name of the database"
  value       = module.rds.db_name
}

output "rds_master_password" {
  description = "Master password for the RDS instance"
  value       = local.db_password_effective
  sensitive   = true
}

# ──────────────────────────────────────────────
# Access helpers
# ──────────────────────────────────────────────
output "grafana_port_forward_command" {
  description = "Command to access Grafana locally"
  value       = "kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring"
}

output "grafana_admin_username" {
  description = "Grafana admin username"
  value       = "admin"
}

output "grafana_admin_password" {
  description = "Grafana admin password"
  value       = local.grafana_admin_password_effective
  sensitive   = true
}
