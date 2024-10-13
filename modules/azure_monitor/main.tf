resource "azurerm_monitor_action_group" "this" {
  for_each = var.action_groups

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  short_name          = each.value.short_name

  dynamic "email_receiver" {
    for_each = each.value.email_receivers
    content {
      name          = email_receiver.value.name
      email_address = email_receiver.value.email
    }
  }

  tags = each.value.tags
}


resource "azurerm_monitor_metric_alert" "this" {
  for_each = var.metric_alerts

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  scopes              = each.value.scopes
  description         = each.value.description
  frequency           = each.value.frequency
  window_size         = each.value.window_size
  severity            = each.value.severity
  target_resource_type = each.value.target_resource_type 
  target_resource_location = each.value.target_resource_location
    
  dynamic "criteria" {
    for_each = each.value.criteria
    content {
      metric_namespace = criteria.value.metric_namespace
      metric_name      = criteria.value.metric_name
      aggregation      = criteria.value.aggregation
      operator         = criteria.value.operator
      threshold        = criteria.value.threshold
    }
  }

  dynamic "action" {
    for_each = each.value.action_group_ids
    content {
      action_group_id = azurerm_monitor_action_group.this[action.value].id
    }
  }

  tags = each.value.tags
}

/*
resource "azurerm_monitor_scheduled_query_rules_alert" "this" {
  for_each = var.scheduled_query_rules

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location  # Required attribute "location"
  description         = each.value.description
  frequency           = each.value.frequency
  severity            = each.value.severity
  time_window         = each.value.time_window  # Required attribute "time_window"

  data_source_id = each.value.data_source_id  # Log Analytics Workspace ID

  # Correct trigger block
  trigger {
    operator  = each.value.operator   # Use "operator" for threshold comparison
    threshold = each.value.threshold  # Numeric threshold value
  }

  dynamic "action" {
    for_each = each.value.action_group_ids
    content {
      action_group = azurerm_monitor_action_group.this[action.value].id  # Correct attribute "action_group"
    }
  }

  query = each.value.query

  tags = each.value.tags
}
*/