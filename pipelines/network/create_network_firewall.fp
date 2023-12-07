pipeline "create_network_firewall" {
  title       = "Create Network Firewall"
  description = "Create an Azure Firewall."

  tags = {
    type = "featured"
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

  param "firewall_name" {
    type        = string
    description = "Azure Firewall name."
  }

  step "container" "create_network_firewall" {
    image = "my-azure-image"
    cmd   = ["network", "firewall", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.firewall_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "firewall" {
    description = "The created network firewall."
    value       = jsondecode(step.container.create_network_firewall.stdout)
  }
}
