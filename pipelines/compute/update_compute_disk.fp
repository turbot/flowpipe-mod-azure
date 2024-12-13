pipeline "update_compute_disk" {
  title       = "Update Compute Disk"
  description = "Update a compute disk."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "disk_name" {
    type        = string
    description = "The name of the disk to update."
  }

  param "disk_access_id" {
    type        = string
    description = "The resource ID of the disk access resource to associate with the disk."
    optional    = true
  }

  param "data_access_auth_mode" {
    type        = bool
    description = "The data access authentication mode to be updated for disk."
    optional    = true
  }

  step "container" "update_compute_disk" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = concat(
      ["disk", "update",
      "--name", param.disk_name,
      "--resource-group", param.resource_group,
      "--subscription", param.subscription_id],
      param.disk_access_id != null ? ["--network-access-policy", "AllowPrivate", "--disk-access", param.disk_access_id] : [],
      param.data_access_auth_mode != null ? ["--data-access-auth-mode", param.data_access_auth_mode ? "AzureActiveDirectory" : ""] : []
    )

    env = param.conn.env
  }

  output "disk" {
    description = "The updated compute disk details."
    value       = jsondecode(step.container.update_compute_disk.stdout)
  }
}
