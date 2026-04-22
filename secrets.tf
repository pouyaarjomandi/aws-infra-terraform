# ──────────────────────────────────────────────
# Generated secrets for local/demo environments
# ──────────────────────────────────────────────
resource "random_password" "grafana_admin" {
  length           = 24
  special          = true
  override_special = "!#$%^&*()-_=+[]{}:?"
}

resource "random_password" "db_master" {
  length           = 24
  special          = true
  override_special = "!#$%^&*()-_=+[]{}:?"
}

locals {
  environment                      = var.environment != "" ? var.environment : terraform.workspace
  grafana_admin_password_effective = coalesce(var.grafana_admin_password, random_password.grafana_admin.result)
  db_password_effective            = coalesce(var.db_password, random_password.db_master.result)
  slack_enabled                    = var.alerting_slack_webhook_url != null && trimspace(var.alerting_slack_webhook_url) != ""
}
