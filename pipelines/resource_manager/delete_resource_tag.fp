pipeline "delete_resource_tag" {
  title       = "Delete Resource Tag"
  description = "Delete tags on a specific resource."

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

  param "resource_id" {
    type        = string
    description = "The resource identifier for the entity being tagged. A resource, a resource group or a subscription may be tagged."
  }

  step "container" "delete_resource_tag" {
    image = "my-azure-image"
    cmd   = ["tag", "delete", "--yes", "--resource-id", param.resource_id]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "tag" {
    description = "The deleted resource tag."
    value       = jsondecode(step.container.delete_resource_tag.stdout)
  }
}
