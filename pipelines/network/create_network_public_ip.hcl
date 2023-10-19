pipeline "create_network_public_ip" {
  title       = "Create Network Public IP"
  description = "Create a public IP address."

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

  param "public_ip_name" {
    type        = string
    description = "The name of the public IP address."
  }

  param "sku" {
    type        = string
    description = "Name of a public IP address SKU."
    optional    = true
  }

  step "container" "create_network_public_ip" {
    image = "my-azure-image"
    cmd = concat(
      ["network", "public-ip", "create", "-g", param.resource_group, "--subscription", param.subscription_id, "-n", param.public_ip_name],
      param.sku != null ? concat(["--sku", param.sku]) : []
    )

    env = {
      AZURE_TENANT_ID     = param.tenant_id
      AZURE_CLIENT_ID     = param.client_id
      AZURE_CLIENT_SECRET = param.client_secret
    }
  }

  output "stdout" {
    description = "Network public IP create output."
    value       = jsondecode(step.container.create_network_public_ip.stdout)
  }

  output "stderr" {
    description = "Network public IP create error."
    value       = step.container.create_network_public_ip.stderr
  }
}
