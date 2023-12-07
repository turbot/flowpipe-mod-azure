pipeline "test_create_compute_virtual_machine" {
  title       = "Test Create Compute Virtual Machine"
  description = "Test the create_compute_virtual_machine pipeline."

  tags = {
    type = "test"
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

  param "vm_name" {
    type        = string
    description = "The name of the Virtual Machine."
    default     = "flowpipe-test-vm-${uuid()}"
  }

  param "vm_image" {
    type        = string
    description = "The OS image for the Virtual Machine."
    default     = "Ubuntu2204"
  }

  param "generate_ssh_keys" {
    type        = string
    description = "Generate SSH keys for the Virtual Machine."
    default     = true
  }

  param "no_wait" {
    type        = bool
    description = "Do not wait for the long-running operation to finish."
    default     = true
  }

  step "pipeline" "create_compute_virtual_machine" {
    pipeline = pipeline.create_compute_virtual_machine
    args = {
      vm_name           = param.vm_name
      vm_image          = param.vm_image
      no_wait           = param.no_wait
      generate_ssh_keys = param.generate_ssh_keys
      client_id         = param.client_id
      client_secret     = param.client_secret
      tenant_id         = param.tenant_id
      resource_group    = param.resource_group
      subscription_id   = param.subscription_id
    }
  }

  step "sleep" "sleep" {
    depends_on = [step.pipeline.create_compute_virtual_machine]
    duration   = "20s"
  }

  step "pipeline" "get_compute_virtual_machine" {
    if         = is_error(step.pipeline.create_compute_virtual_machine) == false
    depends_on = [step.sleep.sleep]

    pipeline = pipeline.get_compute_virtual_machine
    args = {
      vm_name         = param.vm_name
      client_id       = param.client_id
      client_secret   = param.client_secret
      tenant_id       = param.tenant_id
      resource_group  = param.resource_group
      subscription_id = param.subscription_id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_compute_virtual_machine" {
    if = is_error(step.pipeline.create_compute_virtual_machine) == false
    # Don't run before we've had a chance to get the VM
    depends_on = [step.pipeline.get_compute_virtual_machine]

    pipeline = pipeline.delete_compute_virtual_machine
    args = {
      vm_name         = param.vm_name
      client_id       = param.client_id
      client_secret   = param.client_secret
      tenant_id       = param.tenant_id
      resource_group  = param.resource_group
      subscription_id = param.subscription_id
    }
  }

  output "vm_name" {
    description = "The name of the Virtual Machine."
    value       = param.vm_name
  }

  output "create_compute_virtual_machine" {
    description = "Check for pipeline.create_compute_virtual_machine."
    value       = is_error(step.pipeline.create_compute_virtual_machine) == false ? "succeeded" : "failed"
  }

  output "get_compute_virtual_machine" {
    description = "Check for pipeline.get_compute_virtual_machine."
    value       = is_error(step.pipeline.get_compute_virtual_machine) == false ? "succeeded" : "failed"
  }

  output "delete_compute_virtual_machine" {
    description = "Check for pipeline.delete_compute_virtual_machine."
    value       = is_error(step.pipeline.delete_compute_virtual_machine) == false ? "succeeded" : "failed"
  }
}
