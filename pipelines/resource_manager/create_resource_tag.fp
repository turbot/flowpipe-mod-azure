pipeline "create_resource_tag" {
  title       = "Create Resource Tag"
  description = "Create tags on a specific resource."

  tags = {
    type = "featured"
  }

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

  param "create_tags" {
    type        = map
    description = "The resource Tags. Example tagKey:tagValue."
  }

  param "resource_id" {
    type        = string
    description = "The resource identifier for the entity being tagged. A resource, a resource group or a subscription may be tagged."
  }

  step "container" "create_resource_tag" {
    image = "my-azure-image"
    cmd = concat(
      ["tag", "create", "--resource-id", param.resource_id, "--tags"],
      [for key, value in param.create_tags : "${key}=${value}"],
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "tag" {
    description = "The created resource tag."
    value       = jsondecode(step.container.create_resource_tag.stdout)
  }
}
