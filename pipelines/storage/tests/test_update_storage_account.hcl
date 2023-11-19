pipeline "test_update_storage_account" {
  title       = "Test Update Storage Account"
  description = "Test the update_storage_account pipeline."

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
    default     = var.subscription_id
    # TODO: Add once supported
    #sensitive   = true
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
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_secret" {
    type        = string
    description = local.client_secret_param_description
    default     = var.client_secret
    # TODO: Add once supported
    #sensitive   = true
  }

  param "client_id" {
    type        = string
    description = local.client_id_param_description
    default     = var.client_id
    # TODO: Add once supported
    #sensitive   = true
  }

  param "account_name" {
    type        = string
    description = "The storage account name."
    default     = "flowpipe-test-storage-account-${uuid()}"
  }

  param "access_tier" {
    type        = string
    description = "The access tier is used for billing."
    default     = "Cool"
  }

  param "public_network_access" {
    type        = bool
    description = "Enable or disable public network access to the storage account."
    default     = false
  }

  step "pipeline" "create_storage_account" {
    pipeline = pipeline.create_storage_account
    args = {
      account_name    = param.account_name
      client_id       = param.client_id
      client_secret   = param.client_secret
      tenant_id       = param.tenant_id
      resource_group  = param.resource_group
      subscription_id = param.subscription_id
    }
  }

  step "pipeline" "update_storage_account_public_network_access" {
    if       = strcontains(step.pipeline.create_storage_account.stderr, "ERROR:") == false
    pipeline = pipeline.update_storage_account_public_network_access
    args = {
      account_name          = param.account_name
      client_id             = param.client_id
      client_secret         = param.client_secret
      tenant_id             = param.tenant_id
      resource_group        = param.resource_group
      subscription_id       = param.subscription_id
      public_network_access = param.public_network_access
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "update_storage_account_access_tier" {
    if       = strcontains(step.pipeline.create_storage_account.stderr, "ERROR:") == false
    pipeline = pipeline.update_storage_account_access_tier
    args = {
      account_name    = param.account_name
      client_id       = param.client_id
      client_secret   = param.client_secret
      tenant_id       = param.tenant_id
      resource_group  = param.resource_group
      subscription_id = param.subscription_id
      access_tier     = param.access_tier
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_storage_account" {
    if = strcontains(step.pipeline.create_storage_account.stderr, "ERROR:") == false
    # Don't run before we've had a chance to update the storage account
    depends_on = [
      step.pipeline.update_storage_account_public_network_access,
      step.pipeline.update_storage_account_access_tier
    ]

    pipeline = pipeline.delete_storage_account
    args = {
      account_name    = param.account_name
      client_id       = param.client_id
      client_secret   = param.client_secret
      tenant_id       = param.tenant_id
      resource_group  = param.resource_group
      subscription_id = param.subscription_id
    }
  }

  output "account_name" {
    description = "The storage account name."
    value       = param.account_name
  }

  output "create_storage_account" {
    description = "Check for pipeline.create_storage_account."
    value       = strcontains(step.pipeline.create_storage_account.stderr, "ERROR:") == false ? "succeeded" : "failed: ${step.pipeline.create_storage_account.stderr}"
  }

  output "update_storage_account_public_network_access" {
    description = "Check for pipeline.update_storage_account_public_network_access."
    value       = strcontains(step.pipeline.update_storage_account_public_network_access.stderr, "ERROR:") == false ? "succeeded: ${step.pipeline.update_storage_account_public_network_access.stdout.publicNetworkAccess}" : "failed: ${step.pipeline.update_storage_account_public_network_access.stderr}"
  }

  output "update_storage_account_access_tier" {
    description = "Check for pipeline.update_storage_account_access_tier."
    value       = strcontains(step.pipeline.update_storage_account_access_tier.stderr, "ERROR:") == false ? "succeeded ${step.pipeline.update_storage_account_access_tier.stdout.accessTier}" : "failed: ${step.pipeline.update_storage_account_access_tier.stderr}"
  }

  output "delete_storage_account" {
    description = "Check for pipeline.delete_storage_account."
    value       = step.pipeline.delete_storage_account.stderr == "" ? "succeeded" : "failed: ${step.pipeline.delete_storage_account.stderr}"
  }
}
