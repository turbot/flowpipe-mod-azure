pipeline "list_compute_virtual_machines" {
  title       = "List Compute Virtual Machines"
  description = "List Compute Virtual Machines."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
    default     = var.resource_group
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

  param "query" {
    type        = string
    description = "A JMESPath query to use in filtering the response data."
    optional    = true
  }

  step "container" "list_compute_virtual_machines" {
    image = "my-azure-image"
    cmd = concat(
      ["vm", "list", "-g", param.resource_group, "--subscription", param.subscription_id],
      param.query != null ? ["--query", param.query] : [],
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "compute_virtual_machines" {
    description = "List of compute virtual machines."
    value       = step.container.list_compute_virtual_machines.stdout
  }
}
