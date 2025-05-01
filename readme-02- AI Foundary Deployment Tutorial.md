# 02 - AI Foundary Deployment Tutorial

---

## ⚠️ Important Note

> **Currently, there is a known issue affecting the automated creation of AI Hub and AI Project resources.**  
>
> As a temporary workaround, we recommend manually creating the **AI Hub** and **AI Project** through the Azure Portal using the standard graphical interface. Once created, these resources can still be referenced and configured within your deployment pipeline.
>
> Our team is actively working on resolving this bug in the Bicep module to restore full automation.

---

This manual provides step-by-step instructions for deploying a complete AI infrastructure on Azure using Bash scripts and Bicep templates.

---

## 1. Purpose

**AI Foundary** enables standardized, automated deployment of critical Azure services for AI workloads, including:

- Azure OpenAI Service (GPT and Embedding models)
- Azure Cognitive Search
- Azure Key Vault
- Azure Storage Account
- Azure Container Registry
- Application Insights & Log Analytics
- Azure AI Hub & AI Project

---

## 2. Requirements

Before starting, ensure the following:

- Azure CLI is installed and authenticated (`az login`)
- You have an active Azure subscription
- Bash environment (Linux, macOS, or WSL)
- Bicep CLI (or Azure CLI with Bicep support)
- Sufficient permissions to create Azure resources

---

## 3. Project Structure

```
ai_foundary/
├── .env_example             # Sample environment variables
├── .env                     # Actual deployment configuration
├── deploy.sh                # Main deployment script
├── main.bicep               # Root Bicep template
└── modules/                 # Modular Bicep files
```

---

## 4. Initial Setup

### Step 1: Configure Environment Variables

Copy the sample file:

```bash
cp .env_example .env
```

Edit `.env` with your values:

```env
SOLUTION_NAME=lexatlas
SOLUTION_LOCATION=eastus2
KEY_VAULT_NAME=lexatlas-kv
SUBSCRIPTION_ID=xxxx-xxxx-xxxx
RESOURCE_GROUP_NAME=lexatlas-rg
MANAGED_IDENTITY_OBJECT_ID=xxxxxxxx
GPT_MODEL_NAME=gpt-4
GPT_MODEL_VERSION=2024-02-15-preview
GPT_DEPLOYMENT_CAPACITY=10
EMBEDDING_MODEL=text-embedding-ada-002
EMBEDDING_DEPLOYMENT_CAPACITY=5
```

---

## 5. Infrastructure Deployment

### Step 2: Execute the Deployment Script

```bash
bash deploy.sh
```

This script will:

- Validate required variables
- Authenticate with Azure
- Create the resource group if it does not exist
- Deploy the full infrastructure using `main.bicep`

---

## 6. Services Deployed

The following Azure resources are provisioned:

1. **Key Vault** – For storing secrets
2. **Log Analytics & Application Insights** – For monitoring
3. **Azure Container Registry** – For storing container images
4. **Storage Account** – For general data storage
5. **Azure OpenAI Service** – With GPT and embedding models
6. **Azure Cognitive Search** – For semantic search
7. **AI Hub** – Azure ML workspace in hub mode
8. **AI Project** – Azure ML workspace in project mode
9. **Secrets** – Automatically pushed to Key Vault

> Note: The OpenAI connection inside AI Hub is currently commented out. You can enable it in `ai-hub.bicep` manually if needed.

---

## 7. Validation

After deployment, you can review all resources in the Azure Portal under the specified resource group. You can also retrieve keys and endpoints via Azure CLI or check outputs printed in the terminal.

---

## 8. Common Errors

- **`Error: <var> is not set`**  
  Ensure all variables are defined in your `.env` file.

- **`Deployment failed`**  
  Inspect the Azure Portal > Resource Group > Deployments for detailed logs.

- **Permission errors**  
  Verify you have "Owner" or "Contributor" permissions on the subscription.

---

## 9. Best Practices

- Use a consistent and unique `SOLUTION_NAME` to avoid naming conflicts.
- Never commit sensitive values in `.env` to version control.
- Reuse and extend the modular `main.bicep` for further customization.
- Prefer using Key Vault to manage API keys securely.
 