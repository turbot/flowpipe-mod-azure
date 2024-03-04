pipeline "test_start_compute_virtual_machine" {
  title       = "Test Start Compute Virtual Machine"
  description = "Test the start_compute_virtual_machine pipeline."

  tags = {
    type = "test"
  }

  param "cred" {
    type        = string
    description = local.cred_param_description
    default     = "default"
  }

  param "subscription_id" {
    type        = string
    description = local.subscription_id_param_description
  }

  param "resource_group" {
    type        = string
    description = local.resource_group_param_description
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
    type        = bool
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
      cred              = param.cred
      vm_name           = param.vm_name
      vm_image          = param.vm_image
      no_wait           = param.no_wait
      generate_ssh_keys = param.generate_ssh_keys
      resource_group    = param.resource_group
      subscription_id   = param.subscription_id
    }
  }

  step "sleep" "sleep" {
    depends_on = [step.pipeline.create_compute_virtual_machine]
    duration   = "60s"
  }

  step "pipeline" "stop_compute_virtual_machine" {
    if         = is_error(step.pipeline.create_compute_virtual_machine) == false
    depends_on = [step.sleep.sleep]

    pipeline = pipeline.stop_compute_virtual_machine
    args = {
      cred            = param.cred
      vm_name         = param.vm_name
      resource_group  = param.resource_group
      subscription_id = param.subscription_id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "start_compute_virtual_machine" {
    if         = is_error(step.pipeline.create_compute_virtual_machine) == false
    depends_on = [step.pipeline.stop_compute_virtual_machine]

    pipeline = pipeline.start_compute_virtual_machine
    args = {
      cred            = param.cred
      vm_name         = param.vm_name
      resource_group  = param.resource_group
      subscription_id = param.subscription_id
    }

    # Ignore errors so we can delete
    error {
      ignore = true
    }
  }

  step "pipeline" "delete_compute_virtual_machine" {
    # Don't run before we've had a chance to start the VM
    depends_on = [step.pipeline.start_compute_virtual_machine]
    if         = is_error(step.pipeline.create_compute_virtual_machine) == false

    pipeline = pipeline.delete_compute_virtual_machine
    args = {
      cred            = param.cred
      vm_name         = param.vm_name
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

  output "stop_compute_virtual_machine" {
    description = "Check for pipeline.stop_compute_virtual_machine."
    value       = is_error(step.pipeline.stop_compute_virtual_machine) == false ? "succeeded" : "failed"
  }

  output "start_compute_virtual_machine" {
    description = "Check for pipeline.start_compute_virtual_machine."
    value       = is_error(step.pipeline.start_compute_virtual_machine) == false ? "succeeded" : "failed"
  }

  output "delete_compute_virtual_machine" {
    description = "Check for pipeline.delete_compute_virtual_machine."
    value       = is_error(step.pipeline.delete_compute_virtual_machine) == false ? "succeeded" : "failed"
  }
}
