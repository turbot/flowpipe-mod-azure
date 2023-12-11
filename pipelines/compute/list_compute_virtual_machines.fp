pipeline "list_compute_virtual_machines" {
  title       = "List Compute Virtual Machines"
  description = "List Compute Virtual Machines."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

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

    env = credential.azure[param.cred].env
  }

  output "virtual_machines" {
    description = "List of compute virtual machines."
    value       = jsondecode(step.container.list_compute_virtual_machines.stdout)
  }
}
