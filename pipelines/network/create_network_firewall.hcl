pipeline "create_network_firewall" {
  title       = "Create Network Firewall"
  description = "Create an Azure Firewall."

  param "subscription_id" {
    type        = string
    description = "Azure Subscription Id."
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "resource_group" {
    type        = string
    description = "Azure Resource Group."
    default     = var.resource_group
    # TODO: Add once supported
    #sensitive   = true
  }

  param "tenant_id" {
    type        = string
    description = "The Microsoft Entra ID tenant (directory) ID."
    default     = var.tenant_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = "A client secret that was generated for the App Registration."
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = "The client (application) ID of an App Registration in the tenant."
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
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

  output "stdout" {
    description = "Firewall details."
    value       = step.container.create_network_firewall.stdout
  }

  output "stderr" {
    description = "Firewall error."
    value       = step.container.create_network_firewall.stderr
  }
}
