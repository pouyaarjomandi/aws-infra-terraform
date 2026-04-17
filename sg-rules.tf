# ══════════════════════════════════════════════
# Runtime security group rules for EKS-created network boundaries
# ══════════════════════════════════════════════

resource "aws_security_group_rule" "eks_backend_http_from_alb" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.security_groups.alb_sg_id
  security_group_id        = module.eks.cluster_primary_security_group_id
  description              = "Allow HTTP from ALB to workloads running on EKS managed nodes"
}

resource "aws_security_group_rule" "rds_postgres_from_eks" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = module.eks.cluster_primary_security_group_id
  security_group_id        = module.security_groups.rds_sg_id
  description              = "Allow PostgreSQL from workloads using the EKS managed node group security boundary"
}
