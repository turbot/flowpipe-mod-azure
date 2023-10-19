pipeline "create_network_nat_gateway" {
  title       = "Create Network Nat Gateway"
  description = "Create a NAT gateway."

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

  param "gateway_name" {
    type        = string
    description = "Name of the NAT gateway."
  }

  step "container" "create_network_nat_gateway" {
    image = "my-azure-image"
    cmd   = ["network", "nat", "gateway", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.gateway_name]

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Network nat gateway create output."
    value       = jsondecode(step.container.create_network_nat_gateway.stdout)
  }

  output "stderr" {
    description = "Network nat gateway create error."
    value       = step.container.create_network_nat_gateway.stderr
  }
}
