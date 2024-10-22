pipeline "delete_resource_tag" {
  title       = "Delete Resource Tag"
  description = "Delete tags on a specific resource."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "resource_id" {
    type        = string
    description = "The resource identifier for the entity being tagged. A resource, a resource group or a subscription may be tagged."
  }

  param "tag" {
    type        = string
    description = "The name of the tag to be deleted."
    optional    = true
  }

  step "container" "delete_resource_tag" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(["tag", "delete", "--yes", "--resource-id", param.resource_id],
      param.tag != null ? ["--name", param.tag] : []
    )

    env = param.conn.env
  }

  output "tag" {
    description = "The deleted resource tag."
    value       = jsondecode(step.container.delete_resource_tag.stdout)
  }
}
