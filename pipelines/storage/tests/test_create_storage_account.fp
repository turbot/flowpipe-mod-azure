pipeline "test_create_storage_account" {
  title       = "Test Create Storage Account"
  description = "Test the create_storage_account pipeline."

  tags = {
    type = "test"
  }

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

  param "account_name" {
    type        = string
    description = "The storage account name."
    default     = "testflowpipe"
  }

  step "pipeline" "create_storage_account" {
    pipeline = pipeline.create_storage_account
    args = {
      conn            = param.conn
      account_name    = param.account_name
      resource_group  = param.resource_group
      subscription_id = param.subscription_id
    }
  }

  step "pipeline" "get_storage_account" {
    if         = is_error(step.pipeline.create_storage_account) == false
    depends_on = [step.pipeline.create_storage_account]
    pipeline   = pipeline.get_storage_account
    args = {
      conn            = param.conn
      account_name    = param.account_name
      resource_group  = param.resource_group
      subscription_id = param.subscription_id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_storage_account" {
    if = is_error(step.pipeline.create_storage_account) == false
    # Don't run before we've had a chance to get the storage account
    depends_on = [step.pipeline.get_storage_account]

    pipeline = pipeline.delete_storage_account
    args = {
      conn            = param.conn
      account_name    = param.account_name
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
    value       = is_error(step.pipeline.create_storage_account) == false ? "succeeded" : "failed"
  }

  output "get_storage_account" {
    description = "Check for pipeline.get_storage_account."
    value       = is_error(step.pipeline.get_storage_account) == false ? "succeeded" : "failed"
  }

  output "delete_storage_account" {
    description = "Check for pipeline.delete_storage_account."
    value       = is_error(step.pipeline.delete_storage_account) == false ? "succeeded" : "failed"
  }
}
