terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}

  tenant_id       = "7fa622ca-d3b0-4a0b-9a1f-544d8b945269"
  subscription_id = "69ea728e-da4b-41a7-99ff-8e84c2384106" # Replace with your subscription ID
  #client_id       = "your_client_id"       # Replace with your client ID
  #client_secret   = "your_client_secret"   # Replace with your client secret
}

data "azurerm_client_config" "current" {}


# Specify the Azure subscription ID, tenant ID, client ID, and client secret
#subscription_id = var.ARM_SUBSCRIPTION_ID
#tenant_id       = var.ARM_TENANT_ID
#client_id       = var.ARM_CLIENT_ID
#client_secret   = var.ARM_CLIENT_SECRET

#subscription_id = env("ARM_SUBSCRIPTION_ID")
#tenant_id       = env("ARM_TENANT_ID")
#client_id       = env("ARM_CLIENT_ID")
#client_secret   = env("ARM_CLIENT_SECRET")



#Get-ChildItem Env:

# Specify the version of the Azure provider
# version = ">=2.0, <3.0"

# Specify the Azure environment
# environment = var.environment

# Specify the location of the Azure Resource Manager instance
# You can also set it globally by using the ARM_LOCATION environment variable
# arm_location = var.arm_location

# Specify additional settings as needed, such as resource pool settings, etc.
# See the Azure provider documentation for available options: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

/*

Subscription ID:
You can find this in the Azure portal under Subscriptions. Each subscription will have its own unique ID.
Tenant ID:
You can find this in the Azure portal under Azure Active Directory > Properties. It's also known as the Directory ID.

Client ID (Application ID):
Sign in to the Azure portal.
In the left-hand navigation pane, select Azure Active Directory.
Under Manage, select App registrations.
Click on New registration.
Provide a Name for your application registration.
Choose the appropriate Supported account types based on your requirements. This determines who can sign in to the application.
For the Redirect URI, you can leave it blank unless you have specific requirements.
Click on Register to create the application.
After registration, you will see the Application (client) ID on the Overview page. This is your Client ID, also known as the Application ID.
Client Secret:
Once you've created the application registration, navigate to Certificates & secrets under your application.
Click on New client secret.
Enter a Description for your client secret to help identify it later.
Choose the desired Expiration for the client secret. You can choose from a predefined expiration period or set it to never expire.
Click on Add.
After creation, the client secret value will be displayed. Note: Make sure to copy this value immediately as it won't be visible again.

*/

