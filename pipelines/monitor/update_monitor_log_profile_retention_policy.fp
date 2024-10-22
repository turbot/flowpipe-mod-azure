pipeline "update_monitor_log_profile_retention_policy" {
  title       = "Update Monitor Log Profile Retention Policy"
  description = "Update the retention policy of an Azure Monitor log profile."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "log_profile_name" {
    type        = string
    description = "The name of the log profile."
  }

  param "retention_days" {
    type        = number
    description = "The number of days to retain the logs."
    default     = 365
  }

  param "retention_enabled" {
    type        = bool
    description = "Whether the retention policy is enabled."
    default     = true
  }

  param "location" {
    type        = string
    description = "Whether the retention policy is enabled."
    default     = "global"
  }

  step "container" "update_monitor_log_profile_retention_policy" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = [
      "monitor", "log-profiles", "update",
      "--name", param.log_profile_name,
      "--subscription", param.subscription_id,
      "--set", format("location=%s retentionPolicy.enabled=%s retentionPolicy.days=%d", param.location, param.retention_enabled ? "true" : "false", param.retention_days)
    ]

    env = param.conn.env
  }

  output "log_profile" {
    description = "The updated monitor log profile details."
    value       = jsondecode(step.container.update_monitor_log_profile_retention_policy.stdout)
  }
}
