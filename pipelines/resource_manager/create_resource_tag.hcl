pipeline "create_resource_tag" {
  title       = "Create Resource Tag"
  description = "create a resource tag."

  param "tenant_id" {
    type        = string
    description = "The Azure Tenant Id."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "The value of the Azure Client Secret."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The Azure Client Id."
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "create_tags" {
    type        = map
    description = "The resource Tags. Example tagKey:tagValue."
  }

  param "resource_id" {
    type        = string
    description = "The resource id."
    default     = "/subscriptions/d46d7416-f95f-4771-bbb5-529d4c76659c/resourceGroups/flowpipe/providers/Microsoft.Compute/virtualMachines/testFlowpipe"
  }

  step "container" "create_resource_tag" {
    image = "my-azure-image"
    cmd = concat(
      ["tag", "create", "--resource-id", param.resource_id, "--tags"],
    concat(for key, value in param.create_tags : "tags.${key}=${value}"]),
  )

  env = {
    AZURE_TENANT_ID     = param.tenant_id
    AZURE_CLIENT_ID     = param.client_id
    AZURE_CLIENT_SECRET = param.client_secret
  }
}

output "disk_out" {
  description = "Tag details."
  value       = step.container.create_resource_tag.stdout
}

output "disk_err" {
  description = "Tag error."
  value       = step.container.create_resource_tag.stderr
}
}
