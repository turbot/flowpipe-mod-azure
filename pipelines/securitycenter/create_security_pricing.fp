pipeline "create_security_pricing" {
  title       = "Create Security Pricing"
  description = "Set the pricing tier for Azure Security Center on a specific resource type."

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "resource_type" {
    type        = string
    description = "The resource type for which to set the pricing tier. Example: AppServices, SQLServers, StorageAccounts, etc."
  }

  param "tier" {
    type        = string
    description = "The pricing tier to set. Example: Free, Standard."
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  step "container" "create_security_pricing" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = [
      "security", "pricing", "create",
      "--name", param.resource_type,
      "--tier", param.tier,
      "--subscription", param.subscription_id
    ]

    env = credential.azure[param.cred].env
  }

  output "security_pricing" {
    description = "The security pricing details."
    value       = jsondecode(step.container.create_security_pricing.stdout)
  }
}
