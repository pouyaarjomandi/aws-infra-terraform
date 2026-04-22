resource "helm_release" "kube_prometheus_stack" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.kube_prometheus_stack_chart_version
  namespace  = "monitoring"

  create_namespace = true
  timeout          = 1200
  atomic           = true
  cleanup_on_fail  = true
  wait             = true
  max_history      = 10

  values = [
    file("${path.module}/helm/prometheus/values.yaml"),
    file("${path.module}/helm/grafana/values.yaml"),
    templatefile("${path.module}/helm/alertmanager/values.tftpl", {
      slack_enabled          = local.slack_enabled
      slack_webhook_url      = var.alerting_slack_webhook_url
      slack_channel          = var.alerting_slack_channel
      slack_critical_channel = var.alerting_slack_critical_channel
    }),
    file("${path.module}/helm/alertmanager/alert-rules.yaml")
  ]

  set_sensitive {
    name  = "grafana.adminPassword"
    value = local.grafana_admin_password_effective
    type  = "string"
  }

  depends_on = [
    module.eks,
    aws_eks_addon.ebs_csi_driver,
    kubernetes_storage_class_v1.gp3,
  ]
}
