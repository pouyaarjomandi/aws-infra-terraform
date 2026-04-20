output "lbc_role_arn" {
  description = "ARN of the IAM role for AWS Load Balancer Controller"
  value       = aws_iam_role.lbc.arn
}

output "ebs_csi_role_arn" {
  description = "ARN of the IAM role for the EBS CSI driver"
  value       = aws_iam_role.ebs_csi.arn
}

output "cluster_autoscaler_role_arn" {
  description = "ARN of the IAM role for Cluster Autoscaler"
  value       = aws_iam_role.cluster_autoscaler.arn
}
