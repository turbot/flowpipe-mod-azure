pipeline "list_compute_virtual_machines" {
  title       = "List Compute Virtual Machines"
  description = "List details of Virtual Machines."

  param "conn" {
    type        = connection.azure
    description = local.conn_param_description
    default     = connection.azure.default
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
  }

  param "query" {
    type        = string
    description = "JMESPath query string."
    optional    = true
  }

  step "container" "list_compute_virtual_machines" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"

    cmd = concat(
       ["vm", "list", "-g", param.resource_group, "--subscription", param.subscription_id],
       param.query != null ? ["--query", param.query] : [],
    )

    env = param.conn.env
  }

  output "virtual_machines" {
    description = "List of compute virtual machines."
    value       = jsondecode(step.container.list_compute_virtual_machines.stdout)
  }
}
