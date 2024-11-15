pipeline "update_compute_disk_encryption_with_cmk" {
  title       = "Update Disk Encryption with Customer-Managed Key"
  description = "Update an Azure disk to use encryption at rest with a customer-managed key from a Disk Encryption Set."

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

  param "disk_encryption_set_id" {
    type        = string
    description = "The resource ID of the Disk Encryption Set to use for encryption."
  }

  step "container" "update_disk_encryption" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "disk", "update",
      "--name", param.disk_name,
      "--resource-group", param.resource_group,
      "--subscription", param.subscription_id,
      "--encryption-type", "EncryptionAtRestWithCustomerKey",
      "--disk-encryption-set", param.disk_encryption_set_id
    ]

    env = param.conn.env
  }

  output "disk_encryption_status" {
    description = "The updated encryption status of the disk."
    value       = jsondecode(step.container.update_disk_encryption.stdout)
  }
}
