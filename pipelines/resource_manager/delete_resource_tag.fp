pipeline "delete_resource_tag" {
  title       = "Delete Resource Tag"
  description = "Delete tags on a specific resource."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
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
    image = "my-azure-image"
    cmd = concat(["tag", "delete", "--yes", "--resource-id", param.resource_id],
      param.tag != null ? ["--name", param.tag] : []
    )

    env = credential.azure[param.cred].env
  }

  output "tag" {
    description = "The deleted resource tag."
    value       = jsondecode(step.container.delete_resource_tag.stdout)
  }
}
