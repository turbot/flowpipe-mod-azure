pipeline "update_resource_tag" {
  title       = "Update Resource Tag"
  description = "Selectively update the set of tags on a specific resource."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "operation" {
    type        = string
    description = "The update operation. Options are Merge, Replace and Delete."
  }

  param "resource_id" {
    type        = string
    description = "The resource identifier for the entity being tagged. A resource, a resource group or a subscription may be tagged."
  }

  param "tags" {
    type        = map
    description = "The tags to be updated on the resource. Example tagKey:tagValue."
  }

  step "container" "update_resource_tag" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      ["tag", "update", "--resource-id", param.resource_id, "--operation", param.operation, "--tags"],
      [for key, value in param.tags : "${key}=${value}"],
    )

    env = param.conn.env
  }

  output "tag" {
    description = "The updated resource tag."
    value       = jsondecode(step.container.update_resource_tag.stdout)
  }
}
