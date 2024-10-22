pipeline "delete_sql_server_firewall_rule" {
  title       = "Delete SQL Server Firewall Rule"
  description = "Delete a firewall rule from the specified SQL server."

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

  param "server_name" {
    type        = string
    description = "The SQL server name."
  }

  param "firewall_rule_name" {
    type        = string
    description = "The firewall rule name."
  }

  step "container" "delete_sql_server_firewall_rule" {
    image = "ghcr.io/turbot/flowpipe-image-azure-cli"
    cmd   = ["sql", "server", "firewall-rule", "delete", "-g", param.resource_group, "--subscription", param.subscription_id, "--server", param.server_name, "--name", param.firewall_rule_name]

    env = param.conn.env
  }
  
}
