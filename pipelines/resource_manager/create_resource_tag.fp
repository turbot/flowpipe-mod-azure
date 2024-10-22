pipeline "create_resource_tag" {
  title       = "Create Resource Tag"
  description = "Create tags on a specific resource."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "tags" {
    type        = map
    description = "The tags to be applied on the resource. Example tagKey:tagValue."
  }

  param "resource_id" {
    type        = string
    description = "The resource identifier for the entity being tagged. A resource, a resource group or a subscription may be tagged."
  }

  step "container" "create_resource_tag" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd = concat(
      ["tag", "create", "--resource-id", param.resource_id, "--tags"],
      [for key, value in param.tags : "${key}=${value}"],
    )

    env = param.conn.env
  }

  output "tag" {
    description = "The created resource tag."
    value       = jsondecode(step.container.create_resource_tag.stdout)
  }
}
