# ══════════════════════════════════════════════
# Cluster Autoscaler
# ══════════════════════════════════════════════

resource "kubernetes_service_account_v1" "cluster_autoscaler" {
  metadata {
    name      = "cluster-autoscaler"
    namespace = "kube-system"
  }

  depends_on = [module.eks]
}

resource "aws_eks_pod_identity_association" "cluster_autoscaler" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = kubernetes_service_account_v1.cluster_autoscaler.metadata[0].name
  role_arn        = module.addons_pod_identity.cluster_autoscaler_role_arn

  depends_on = [aws_eks_addon.pod_identity_agent, kubernetes_service_account_v1.cluster_autoscaler, module.addons_pod_identity]
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.46.0"
  namespace  = "kube-system"
  timeout    = 600

  set {
    name  = "autoDiscovery.clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = kubernetes_service_account_v1.cluster_autoscaler.metadata[0].name
  }

  set {
    name  = "extraArgs.balance-similar-node-groups"
    value = "true"
  }

  set {
    name  = "extraArgs.skip-nodes-with-system-pods"
    value = "false"
  }

  depends_on = [aws_eks_pod_identity_association.cluster_autoscaler]
}
