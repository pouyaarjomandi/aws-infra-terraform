output "alb_sg_id" {
  description = "Security Group ID for ALBs created by AWS Load Balancer Controller"
  value       = aws_security_group.alb.id
}

output "rds_sg_id" {
  description = "Security Group ID for RDS database"
  value       = aws_security_group.rds.id
}
