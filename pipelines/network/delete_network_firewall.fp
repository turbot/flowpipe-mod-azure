pipeline "delete_network_firewall" {
  title       = "Delete Network Firewall"
  description = "Delete an Azure Firewall."

  tags = {
    type = "featured"
  }

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

  param "firewall_name" {
    type        = string
    description = "Azure Firewall name."
  }

  step "container" "delete_network_firewall" {
    image = "my-azure-image"
    cmd   = ["network", "firewall", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.firewall_name]

    env = credential.azure[param.cred].env
  }

  output "firewall" {
    description = "The deleted network firewall details."
    value       = jsondecode(step.container.delete_network_firewall.stdout)
  }
}
