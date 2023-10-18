pipeline "test_update_storage_account" {
  title       = "Test Update Storage Account"
  description = "Test the update_storage_account pipeline."

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
    if       = startswith("ERROR:", step.pipeline.create_storage_account.stderr) == false
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
    if       = startswith("ERROR:", step.pipeline.create_storage_account.stderr) == false
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
    if = startswith("ERROR:", step.pipeline.create_storage_account.stderr) == false
    # Don't run before we've had a chance to list buckets
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
    value       = startswith("ERROR:", step.pipeline.create_storage_account.stderr) == false ? "succeeded" : "failed: ${step.pipeline.create_storage_account.stderr}"
  }

  output "update_storage_account_public_network_access" {
    description = "Check for pipeline.update_storage_account_public_network_access."
    value       = startswith("ERROR:", step.pipeline.update_storage_account_public_network_access.stderr) == false ? "succeeded" : "failed: ${step.pipeline.update_storage_account_public_network_access.stderr}"
  }

  output "update_storage_account_access_tier" {
    description = "Check for pipeline.update_storage_account_access_tier."
    value       = startswith("ERROR:", step.pipeline.update_storage_account_access_tier.stderr) == false ? "succeeded" : "failed: ${step.pipeline.update_storage_account_access_tier.stderr}"
  }

  output "delete_storage_account" {
    description = "Check for pipeline.delete_storage_account."
    value       = step.pipeline.delete_storage_account.stderr == "" ? "succeeded" : "failed: ${step.pipeline.delete_storage_account.stderr}"
  }
}