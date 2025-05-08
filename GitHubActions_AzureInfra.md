### Setting up Azure Terraform Pipeline

## Prerequisites

Before setting up the pipeline, ensure you have the following:

1. **Azure Subscription**: You need a valid Azure Subscription ID where the resources will be provisioned.

2. **Azure Service Principal**: You need to create a Service Principal to authenticate with Azure via the Azure CLI or other Azure tools. You need the following details:

   * `clientId`
   * `clientSecret`
   * `subscriptionId`
   * `tenantId`

3. **Azure Blob Storage Account**: For storing Terraform state files, you need:

   * **Storage Account**: Create a storage account for storing Terraform state.
   * **Blob Container**: A blob container to store the Terraform state file (`terraform.tfstate`).
   * **Azure Role**: Ensure the Service Principal has the **Storage Blob Data Contributor** role for the Blob Container.

4. **Terraform Installed Locally** (Optional): If you want to run Terraform commands locally before pushing changes, ensure that you have Terraform installed.

5. **GitHub Repository Secrets**: You need to set up the Azure credentials as GitHub Secrets to allow secure access to Azure resources.

---

## Step-by-Step Guide

### 1. Set Up Azure Credentials for GitHub Secrets

You will need to store the Azure credentials securely in your GitHub repository's secrets.

1. Go to your GitHub repository.
2. Click on `Settings`.
3. Scroll down and click on `Secrets and Variables`, then click `Actions`.
4. Click on `New repository secret`.
5. Name the secret `AZURE_CREDENTIALS`.
6. Add the Azure credentials in JSON format. This should look like:

```json
{
  "clientId": "1e64c265-1a41-4adf-972b-16845e7d0c22",
  "clientSecret": "",
  "subscriptionId": "8275bd32-2df4-4467-9201-597dbf8e04a5",
  "tenantId": "0cb5cf3e-229f-499e-9e48-d9a50a041577"
}
```

Ensure that the values are valid and match the ones for your Azure Service Principal.

---

### 2. Create Azure Resources

Use Terraform to create the necessary resources in Azure. The example below includes:

* **Resource Group**
* **Virtual Network**
* **Subnet**
* **Network Interface**
* **Virtual Machine**

You can save the following Terraform configuration in a file like `main.tf`:

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "mcap-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "demo-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "demo-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic" {
  name                = "demo-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "mcap-vm01"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  disable_password_authentication = false
  admin_password = "Azure12345678!"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
```

Make sure to replace `Azure12345678!` with a more secure password if necessary.

---

### 3. Configure Backend for Terraform State

In your `main.tf`, configure the backend for storing Terraform state. This ensures the state is saved in your Azure Blob Storage.

```hcl
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.26.0"
    }
  }

  backend "azurerm" {
    storage_account_name = "mbsmstorageacc"
    container_name       = "terragithubactions"
    key                  = "terraform.tfstate"
    resource_group_name  = "testrg"
    subscription_id      = "8275bd32-2df4-4467-9201-597dbf8e04a5"
  }
}

provider "azurerm" {
  features {}
  subscription_id = "8275bd32-2df4-4467-9201-597dbf8e04a5"
}
```

Ensure the **Storage Account Name**, **Container Name**, and **Resource Group Name** match the Azure resources you set up.

---

### 4. Set Up GitHub Actions Workflow

#### Terraform Pipeline with Manual Approval

Here is a basic GitHub Actions pipeline that will run the Terraform commands for planning and applying the infrastructure.

Create a `.github/workflows/terraform.yml` file in your repository:

```yaml
name: 'Terraform'

on:
  push:
    branches: [ "master" ]
  pull_request:

permissions:
  contents: read

jobs:
  terraform-plan:
    name: 'Terraform Plan'
    runs-on: ubuntu-latest
    environment: production

    defaults:
      run:
        shell: bash

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1

    - name: Azure Login
      uses: azure/login@v2
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Terraform Init
      run: terraform init

    - name: Terraform Plan
      run: terraform apply -input=false

  terraform-apply:
    name: 'Terraform Apply'
    runs-on: ubuntu-latest
    needs: terraform-plan
    environment: production

    defaults:
      run:
        shell: bash

    steps:
    - name: Checkout
      uses: actions/checkout@v4

    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1

    - name: Azure Login
      uses: azure/login@v2
      with:
        creds: ${{ secrets.AZURE_CREDENTIALS }}

    - name: Terraform Init
      run: terraform init

    - name: Terraform Apply
      run: terraform apply -auto-approve -input=false
```

```
## working terraform code without manual approval
# name: 'Terraform'

# on:
#   push:
#     branches: [ "master" ]
#   pull_request:

# permissions:
#   contents: read

# jobs:
#   terraform:
#     name: 'Terraform'
#     runs-on: ubuntu-latest
#     environment: production

#     defaults:
#       run:
#         shell: bash

#     steps:
#     - name: Checkout
#       uses: actions/checkout@v4


#     - name: Setup Terraform
#       uses: hashicorp/setup-terraform@v1

#     - name: Azure Login
#       uses: azure/login@v2
#       with:
#         creds: ${{ secrets.AZURE_CREDENTIALS }}

#     - name: Terraform Init
#       run: terraform init

#     # - name: Terraform Format
#     #   run: terraform fmt -check

#     - name: Terraform Plan
#       run: terraform plan -input=false

#     - name: Terraform Apply
#       if: github.ref == 'refs/heads/master' && github.event_name == 'push'
#       run: terraform apply -auto-approve -input=false
```

This workflow will:

* **Terraform Plan**: Preview the changes.
* **Terraform Apply**: Apply the changes automatically without requiring manual approval if the commit is pushed to the `master` branch.

---

### 5. Testing and Running the Pipeline

1. Push your changes to the GitHub repository.
2. The GitHub Actions workflow will trigger automatically.
3. Check the **Actions** tab in GitHub to monitor the progress and status.

If everything is configured correctly, Terraform will manage the Azure resources as defined in your Terraform configuration.

---

## Troubleshooting

* **Login Issues**: If the pipeline fails due to login errors, ensure your **AZURE\_CREDENTIALS** secret is properly set in your repository.
* **Permissions**: Make sure your Service Principal has sufficient permissions, including the **Contributor** role and **Storage Blob Data Contributor** role for the storage account.
* **State File**: Ensure the storage account and container exist in Azure before running the pipeline to avoid issues with backend initialization.

---
