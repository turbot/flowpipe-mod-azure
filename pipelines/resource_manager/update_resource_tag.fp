pipeline "update_resource_tag" {
  title       = "Update Resource Tag"
  description = "Selectively update the set of tags on a specific resource."

  param "tenant_id" {
    type        = string
    description = local.tenant_id_param_description
    default     = var.tenant_id
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
  }

  param "operation" {
    type        = string
    description = "The update operation. Options are Merge, Replace and Delete."
  }

  param "resource_id" {
    type        = string
    description = "The resource identifier for the entity being tagged. A resource, a resource group or a subscription may be tagged."
  }

  param "update_tags" {
    type        = map
    description = "The resource Tags. Example tagKey:tagValue."
  }

  step "container" "update_resource_tag" {
    image = "my-azure-image"
    cmd = concat(
      ["tag", "update", "--resource-id", param.resource_id, "--operation", param.operation, "--tags"],
      [for key, value in param.update_tags : "${key}=${value}"],
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "resource_tag" {
    description = "The updated resource tag."
    value       = step.container.update_resource_tag.stdout
  }
}
