# ══════════════════════════════════════════════
# AWS Load Balancer Controller
# ══════════════════════════════════════════════

resource "kubernetes_service_account_v1" "aws_load_balancer_controller" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
  }

  depends_on = [module.eks]
}

resource "aws_eks_pod_identity_association" "lbc" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = kubernetes_service_account_v1.aws_load_balancer_controller.metadata[0].name
  role_arn        = module.addons_pod_identity.lbc_role_arn

  depends_on = [aws_eks_addon.pod_identity_agent, kubernetes_service_account_v1.aws_load_balancer_controller, module.addons_pod_identity]
}

resource "helm_release" "aws_load_balancer_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.14.0"
  namespace  = "kube-system"
  timeout    = 600

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account_v1.aws_load_balancer_controller.metadata[0].name
  }

  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }

  depends_on = [aws_eks_pod_identity_association.lbc]
}
