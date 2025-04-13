# Common Commands

## **Authentication & Subscription**
```bash
az login                      # Login to Azure account
az account show              # Show active subscription details
az account list              # List all subscriptions
az account set --subscription <name or id>  # Set active subscription
```

---

## **Resource Group Management**
```bash
az group list                # List resource groups
az group create --name <name> --location <region>   # Create a resource group
az group delete --name <name>  # Delete a resource group
```

---

## **Virtual Machines**
```bash
az vm list                   # List all VMs
az vm create --resource-group <name> --name <vm-name> --image UbuntuLTS --admin-username azureuser --generate-ssh-keys
az vm start --name <vm-name> --resource-group <name>
az vm stop --name <vm-name> --resource-group <name>
az vm delete --name <vm-name> --resource-group <name>
```

---

## **Storage Accounts**
```bash
az storage account list
az storage account create --name <name> --resource-group <rg> --location <loc> --sku Standard_LRS
az storage container create --name <container> --account-name <storage-account>
```

---

## **Azure App Services**
```bash
az webapp list
az webapp create --resource-group <rg> --plan <app-service-plan> --name <app-name> --runtime "DOTNET|6.0"
az webapp log tail --name <app-name> --resource-group <rg>
```

---

## **Azure Key Vault**
```bash
az keyvault list
az keyvault create --name <vault-name> --resource-group <rg> --location <loc>
az keyvault secret set --vault-name <vault> --name <secret-name> --value <value>
az keyvault secret show --vault-name <vault> --name <secret-name>
```

---

## **Monitoring & Insights**
```bash
az monitor metrics list --resource <resource-id> --metric <metric-name>
az monitor activity-log list --resource-group <rg>
```

---

## **Quick Utility**
```bash
az find "vm create"          # Find examples for a specific command
az upgrade                   # Upgrade Azure CLI to the latest version
az configure --defaults group=<rg> location=<location>
```
 