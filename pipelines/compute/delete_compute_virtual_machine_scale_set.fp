pipeline "delete_virtual_machine_scale_set" {
  title       = "Delete Virtual Machine Scale Set"
  description = "Delete an Azure Virtual Machine Scale Set."

  param "cred" {
    type        = string
    description = "The credentials to use for authentication."
    default     = "default"
  }

 	param "subscription_id" {
    type        = string
    description = "The Azure subscription ID."
  }

  param "resource_group" {
    type        = string
    description = "The name of the resource group that contains the App Service Plan."
  }

  param "vmss_name" {
    type        = string
    description = "The name of the Virtual Machine Scale Set."
		default     = "test9000"
  }

  step "container" "delete_virtual_machine_scale_set" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["vmss", "delete", "-g", param.resource_group, "-n", param.vmss_name, "--subscription", param.subscription_id]

    env = credential.azure[param.cred].env
  }
}
