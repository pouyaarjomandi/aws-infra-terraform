locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

resource "aws_iam_policy" "lbc" {
  name        = "${var.project_name}-${var.environment}-lbc-policy"
  description = "IAM policy for AWS Load Balancer Controller"
  policy      = file("${path.module}/lbc-iam-policy.json")

  tags = local.common_tags
}

resource "aws_iam_role" "lbc" {
  name = "${var.project_name}-${var.environment}-lbc-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEksAuthToAssumeRoleForLBCPodIdentity"
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession",
        ]
        Condition = {
          StringEquals = {
            "aws:RequestTag/eks-cluster-arn"            = var.cluster_arn
            "aws:RequestTag/kubernetes-namespace"       = "kube-system"
            "aws:RequestTag/kubernetes-service-account" = "aws-load-balancer-controller"
          }
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-lbc-role"
  })
}

resource "aws_iam_role_policy_attachment" "lbc" {
  policy_arn = aws_iam_policy.lbc.arn
  role       = aws_iam_role.lbc.name
}

resource "aws_iam_role" "ebs_csi" {
  name = "${var.project_name}-${var.environment}-ebs-csi-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEksAuthToAssumeRoleForEbsCsiPodIdentity"
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession",
        ]
        Condition = {
          StringEquals = {
            "aws:RequestTag/eks-cluster-arn"            = var.cluster_arn
            "aws:RequestTag/kubernetes-namespace"       = "kube-system"
            "aws:RequestTag/kubernetes-service-account" = "ebs-csi-controller-sa"
          }
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-ebs-csi-role"
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi" {
  role       = aws_iam_role.ebs_csi.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

# ══════════════════════════════════════════════
# Cluster Autoscaler
# ══════════════════════════════════════════════

resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "${var.project_name}-${var.environment}-cluster-autoscaler-policy"
  description = "IAM policy for Cluster Autoscaler"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:DescribeLaunchConfigurations",
          "autoscaling:DescribeScalingActivities",
          "autoscaling:DescribeTags",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup",
          "ec2:DescribeLaunchTemplateVersions",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeImages",
          "ec2:GetInstanceTypesFromInstanceRequirements",
          "eks:DescribeNodegroup",
        ]
        Resource = "*"
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role" "cluster_autoscaler" {
  name = "${var.project_name}-${var.environment}-cluster-autoscaler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEksAuthToAssumeRoleForClusterAutoscalerPodIdentity"
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession",
        ]
        Condition = {
          StringEquals = {
            "aws:RequestTag/eks-cluster-arn"            = var.cluster_arn
            "aws:RequestTag/kubernetes-namespace"       = "kube-system"
            "aws:RequestTag/kubernetes-service-account" = "cluster-autoscaler"
          }
        }
      }
    ]
  })

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${var.environment}-cluster-autoscaler-role"
  })
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
  role       = aws_iam_role.cluster_autoscaler.name
}
