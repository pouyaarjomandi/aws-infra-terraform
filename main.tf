# ══════════════════════════════════════════════
# 1. VPC - Networking Foundation
# ══════════════════════════════════════════════
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = local.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# ══════════════════════════════════════════════
# 2. Security Groups - ALB and Database
# ══════════════════════════════════════════════
module "security_groups" {
  source = "./modules/security-groups"

  project_name = var.project_name
  environment  = local.environment
  vpc_id       = module.vpc.vpc_id
}

# ══════════════════════════════════════════════
# 3. IAM - Base roles for EKS control plane and nodes
# ══════════════════════════════════════════════
module "iam" {
  source = "./modules/iam"

  project_name = var.project_name
  environment  = local.environment
}

# ══════════════════════════════════════════════
# 4. EKS - Primary application runtime
# ══════════════════════════════════════════════
module "eks" {
  source = "./modules/eks"

  project_name                            = var.project_name
  environment                             = local.environment
  private_subnet_ids                      = module.vpc.private_subnet_ids
  eks_cluster_role_arn                    = module.iam.eks_cluster_role_arn
  eks_nodes_role_arn                      = module.iam.eks_nodes_role_arn
  cluster_version                         = var.cluster_version
  eks_public_access_cidrs                 = var.eks_public_access_cidrs
  eks_control_plane_log_retention_in_days = var.eks_control_plane_log_retention_in_days
  node_instance_types                     = var.node_instance_types
  node_desired_size                       = var.node_desired_size
  node_min_size                           = var.node_min_size
  node_max_size                           = var.node_max_size
  node_disk_size                          = var.node_disk_size
}

# ══════════════════════════════════════════════
# 5. Pod Identity roles for cluster add-ons
# ══════════════════════════════════════════════
module "addons_pod_identity" {
  source = "./modules/addons-pod-identity"

  project_name = var.project_name
  environment  = local.environment
  cluster_arn  = module.eks.cluster_arn
}

# ══════════════════════════════════════════════
# 6. RDS - PostgreSQL Database
# ══════════════════════════════════════════════
module "rds" {
  source = "./modules/rds"

  project_name       = var.project_name
  environment        = local.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  rds_sg_id          = module.security_groups.rds_sg_id
  db_name            = var.db_name
  db_username        = var.db_username
  db_password        = local.db_password_effective
  db_instance_class  = var.db_instance_class
  db_engine_version  = var.db_engine_version
  multi_az           = var.multi_az
}
