location                        = "uk south"
resource_group_name             = "rg_virt_machs"

vnet_name                       = "Vnet_core"
subnet_name                     = "sb_workload"
vnet_resource_group_name        = "RG_Vnet"

keyvault_name                   = "kv-vault003b"
#keyvault_resource_group_name    = "RG-KV"
vm_username       = "vm-adminname"
vm_admin_password_secret        = "vm-adminpassword"
#vm_admin_username               = "adminuser"      # Replace with the actual admin username

# terraform.tfvars
vms = {
  "vm1" = {
    name                      = "migrated-vm1"
    resource_group_name       = "target-rg"
    snapshot_resource_group_name = "snapshot-rg"
    location                  = "eastus"
    size                      = "Standard_D2s_v3"
    os_disk_snapshot_name     = "vm1-os-snapshot"
    os_disk_type             = "Standard_LRS"
    
    interfaces = [
      {
        name                = "vm1-nic1"
        ip_config_name     = "ipconfig1"
        subnet_id          = "/subscriptions/.../subnet1"
        private_ip_address = "10.0.1.10"
      }
    ]
    
    data_disks = [
      {
        name                = "vm1-data1"
        snapshot_name       = "vm1-data1-snapshot"
        storage_account_type = "Standard_LRS"
        lun                 = 0
      }
    ]
    
    admin_username = "adminuser"
    admin_password = "P@ssw0rd123!"
    zone          = "1"
    
    tags = {
      Environment = "Production"
      MigratedFrom = "source-subscription"
    }
  }
  
  "vm2" = {
    # Similar configuration for second VM
    # Add more VMs as needed
  }
}

common_tags = {
  environment = "production"
  project     = "webapp"
  owner       = "devops-team"
}


action_groups = {
  "group1" = {
    name                = "ActionGroup1"
    resource_group_name = "rg_virt_machs"
    short_name          = "AG1"
    email_receivers = [
      {
        name  = "Admin1"
        email = "nextbrand16@gmail.com"
      },
      # {
      #   name  = "Admin2"
      #   email = "admin2@example.com"
      # }
    ]
    tags = {
      Environment = "Production"
    }
  },
  # "group2" = {
  #   name                = "ActionGroup2"
  #   resource_group_name = "rg2"
  #   short_name          = "AG2"
  #   email_receivers = [
  #     {
  #       name  = "Admin3"
  #       email = "admin3@example.com"
  #     },
  #     {
  #       name  = "Admin4"
  #       email = "admin4@example.com"
  #     }
  #   ]
  #   tags = {
  #     Environment = "Development"
  #   }
  # }
}

metric_alerts = {
  "alert1" = {
    name                = "MetricAlert_PowerOff"
    resource_group_name = "rg_virt_machs"
    scopes              = ["/subscriptions/69ea728e-da4b-41a7-99ff-8e84c2384106/resourceGroups/rg_virt_machs"]
    description         = "Alert for Power Off"
    frequency           = "PT5M"
    window_size         = "PT15M"
    severity            = 0
    target_resource_type = "Microsoft.Compute/virtualMachines"
    target_resource_location = "uk south"
    criteria = [
      {
        metric_namespace = "Microsoft.Compute/virtualMachines"
        metric_name      = "VmAvailabilityMetric"
        aggregation      = "Minimum"
        operator         = "LessThanOrEqual"
        threshold        = 0
      }
    ]
    action_group_ids = ["group1"]
    tags = {
      Environment = "Production"
    }
  },

    "alert2" = {
    name                = "MetricAlert_CPU_Usage"
    resource_group_name = "rg_virt_machs"
    scopes              = ["/subscriptions/69ea728e-da4b-41a7-99ff-8e84c2384106/resourceGroups/rg_virt_machs"]
    description         = "Alert for CPU"
    frequency           = "PT5M"
    window_size         = "PT15M"
    severity            = 2
    target_resource_type = "Microsoft.Compute/virtualMachines"
    target_resource_location = "uk south"
    criteria = [
      {
        metric_namespace = "Microsoft.Compute/virtualMachines"
        metric_name      = "Percentage CPU"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 80
      }
    ]
    action_group_ids = ["group1"]
    tags = {
      Environment = "Production"
    }
  },
  
  "alert3" = {
    name                = "MetricAlert_MemoryBytes"
    resource_group_name = "rg_virt_machs"
    scopes              = ["/subscriptions/69ea728e-da4b-41a7-99ff-8e84c2384106/resourceGroups/rg_virt_machs"]
    description         = "Alert for Disk Space"
    frequency           = "PT5M"
    window_size         = "PT15M"
    severity            = 3
    target_resource_type = "Microsoft.Compute/virtualMachines"
    target_resource_location = "uk south"
    criteria = [
      {
        metric_namespace = "Microsoft.Compute/virtualMachines"
        metric_name      = "Available Memory Bytes"
        aggregation      = "Total"
        operator         = "LessThan"
        threshold        = 1000000000
      }
    ]
    action_group_ids = ["group1"]
    tags = {
      Environment = "Development"
    }
  }
}

/*
scheduled_query_rules = {
  # Example of a scheduled query rule for monitoring disk space
  "query_rule1" = {
    name                = "QueryRule1"
    resource_group_name = "rg_virt_machs"
    location            = "uk south"
    description         = "Monitor disk usage"
    frequency           = "PT5M"
    severity            = 2
    time_window         = "PT10M"
    data_source_id      = "/subscriptions/69ea728e-da4b-41a7-99ff-8e84c2384106/resourceGroups/rg_virt_machs/providers/Microsoft.OperationalInsights/workspaces/log-analytics-id"
    query               = <<QUERY
      Perf
      | where ObjectName == "LogicalDisk" and CounterName == "% Free Space"
      | summarize avg(CounterValue) by bin(TimeGenerated, 5m), Computer
    QUERY
    action_group_ids    = ["group1"]
    operator            = "LessThan"  # Correct use of "operator"
    threshold           = 20          # Trigger when disk free space is less than 20%
    tags = {
      Environment = "Production"
    }
  }
}

scheduled_query_rules = {
  "query_rule1" = {
    name                = "QueryRule1"
    resource_group_name = "rg1"
    location            = "East US"        # Required attribute "location"
    description         = "Monitor disk usage"
    frequency           = "PT5M"
    severity            = 2
    time_window         = "PT10M"          # Required attribute "time_window"
    data_source_id      = "/subscriptions/69ea728e-da4b-41a7-99ff-8e84c2384106/resourceGroups/rg_virt_machs/providers/Microsoft.OperationalInsights/workspaces/log-analytics-id"
    query               = <<QUERY
      Perf
      | where ObjectName == "LogicalDisk" and CounterName == "% Free Space"
      | summarize avg(CounterValue) by bin(TimeGenerated, 5m), Computer
    QUERY
    action_group_ids    = ["group1"]
    operator            = "LessThan"       # Required attribute "operator"
    threshold           = 20               # Required attribute "threshold"
    tags = {
      Environment = "Production"
    }
  }
}


*/
