pipeline "test_start_compute_virtual_machine" {
  title       = "Test Start Compute Virtual Machine"
  description = "Test the start_compute_virtual_machine pipeline."

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
    duration   = "60s"
  }

  step "pipeline" "stop_compute_virtual_machine" {
    if         = strcontains(step.pipeline.create_compute_virtual_machine.stderr, "ERROR:") == false
    depends_on = [step.sleep.sleep]

    pipeline = pipeline.stop_compute_virtual_machine
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

  step "pipeline" "start_compute_virtual_machine" {
    if         = strcontains(step.pipeline.create_compute_virtual_machine.stderr, "ERROR:") == false
    depends_on = [step.pipeline.stop_compute_virtual_machine]

    pipeline = pipeline.start_compute_virtual_machine
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
    if = strcontains(step.pipeline.create_compute_virtual_machine.stderr, "ERROR:") == false
    # Don't run before we've had a chance to start the VM
    depends_on = [step.pipeline.start_compute_virtual_machine]

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
    value       = strcontains(step.pipeline.create_compute_virtual_machine.stderr, "ERROR:") == false ? "succeeded" : "failed: ${step.pipeline.create_compute_virtual_machine.stderr}"
  }

  output "stop_compute_virtual_machine" {
    description = "Check for pipeline.stop_compute_virtual_machine."
    value       = strcontains(step.pipeline.stop_compute_virtual_machine.stderr, "ERROR:") == false ? "succeeded" : "failed: ${step.pipeline.stop_compute_virtual_machine.stderr}"
  }

  output "start_compute_virtual_machine" {
    description = "Check for pipeline.start_compute_virtual_machine."
    value       = strcontains(step.pipeline.start_compute_virtual_machine.stderr, "ERROR:") == false ? "succeeded" : "failed: ${step.pipeline.start_compute_virtual_machine.stderr}"
  }

  output "delete_compute_virtual_machine" {
    description = "Check for pipeline.delete_compute_virtual_machine."
    value       = step.pipeline.delete_compute_virtual_machine.stderr == "" ? "succeeded" : "failed: ${step.pipeline.delete_compute_virtual_machine.stderr}"
  }
}