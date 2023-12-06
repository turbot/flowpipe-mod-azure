pipeline "get_compute_virtual_machine_instance_view" {
  title       = "Get Compute Virtual Machine Instance View"
  description = "Get the instance view of a compute virtual machine."

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

  param "vm_name" {
    type        = string
    description = "The name of the Virtual Machine."
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

  step "container" "get_compute_virtual_machine_instance_view" {
    image = "my-azure-image"
    cmd = concat(
      ["vm", "get-instance-view", "--name", param.vm_name, "-g", param.resource_group, "--subscription", param.subscription_id],
      param.query != null ? ["--query", param.query] : [],
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "instance_view" {
    description = "The compute virtual machine instance view."
    value       = step.container.get_compute_virtual_machine_instance_view.stdout
  }
}
