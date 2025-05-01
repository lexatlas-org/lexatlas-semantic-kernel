# AI Foundary - Azure Infrastructure Deployment

## Overview

**AI Foundary** is a fully automated infrastructure deployment project for Azure, tailored for AI solutions.  
It deploys essential services such as Azure OpenAI, Azure Cognitive Search, Azure Key Vault, Storage Accounts, Application Insights, Azure Container Registry, AI Hub, and AI Projects using Bicep templates and an automated shell script.

This project enables a quick, secure, and standardized way to bootstrap AI-based solutions in Microsoft Azure.

---

## Architecture

The deployment includes:

- Azure OpenAI Service
- GPT and Embedding Model Deployments
- Azure Cognitive Search Service
- Azure Key Vault for secure storage of secrets
- Azure Storage Account
- Application Insights and Log Analytics for monitoring
- Azure Container Registry (ACR)
- AI Hub (Azure ML Workspace in Hub mode)
- AI Project (Azure ML Workspace in Project mode)
- Key Vault Secrets Management
- Optional Role-Based Access Control (RBAC)

---

## Project Structure

```
ai_foundary/
├── .env_example             # Sample environment file
├── .env                     # Your actual deployment environment variables
├── deploy.sh                # Shell script to deploy infrastructure
├── main.bicep               # Main Bicep file coordinating the deployment
└── modules/                 # Bicep modules
    ├── openai-service.bicep
    ├── openai-deployments.bicep
    ├── search.bicep
    ├── storage.bicep
    ├── log-analytics.bicep
    ├── app-insights.bicep
    ├── container-registry.bicep
    ├── key-vault.bicep
    ├── keyvault-secrets.bicep
    ├── ai-hub.bicep
    ├── ai-project.bicep
    └── rbac.bicep
```

---

## Prerequisites

- Azure CLI installed and logged in
- Azure subscription with permissions to create resources
- Bicep CLI (or Azure CLI extension for Bicep)
- Bash environment (Linux, MacOS, or Windows Subsystem for Linux)

---

## Setup Instructions

### 1. Configure Environment Variables

Copy the provided `.env_example` to `.env` and fill in the appropriate values:

```bash
cp .env_example .env
```

Edit `.env` and update:

- `SOLUTION_NAME`
- `SOLUTION_LOCATION`
- `KEY_VAULT_NAME`
- `SUBSCRIPTION_ID`
- `RESOURCE_GROUP_NAME`
- `MANAGED_IDENTITY_OBJECT_ID`
- OpenAI configuration parameters

Example for GPT-4o:

```bash
GPT_MODEL_NAME=gpt-4o
GPT_MODEL_VERSION=2024-11-20
```

### 2. Deploy Infrastructure

Execute the deployment script:

```bash
bash deploy.sh
```

The script will:

- Validate your environment variables
- Authenticate against Azure
- Set your Azure subscription
- Create the resource group (if it does not exist)
- Deploy the infrastructure using the `main.bicep` file

---

## Deployment Flow

1. Creates Key Vault
2. Creates Log Analytics Workspace and Application Insights
3. Creates Azure Container Registry
4. Creates Storage Account
5. Creates Azure OpenAI Service
6. Deploys GPT model and Embedding model
7. Creates Azure Cognitive Search Service
8. Deploys AI Hub (Hub workspace)
9. Deploys AI Project (Project workspace)
10. Populates Key Vault with secrets

---

## Notes

- OpenAI Connection inside AI Hub is currently commented out. Future versions may include automatic connection.
- Make sure your Azure subscription has quota for Azure OpenAI service.
- Validate that the `MANAGED_IDENTITY_OBJECT_ID` has sufficient permissions if you enable RBAC role assignments.
- Some modules have strict Azure region constraints depending on your GPT models.

---

## Troubleshooting

- Ensure Azure CLI is authenticated: `az login`
- Ensure your subscription is active: `az account show`
- If deployment fails, review Azure Portal > Resource Group > Deployments for detailed error logs.
- Validate the required service providers are registered:

```bash
az provider register --namespace Microsoft.CognitiveServices
az provider register --namespace Microsoft.MachineLearningServices
az provider register --namespace Microsoft.KeyVault
az provider register --namespace Microsoft.Search
az provider register --namespace Microsoft.Insights
az provider register --namespace Microsoft.Storage
az provider register --namespace Microsoft.ContainerRegistry
```

---

## Future Improvements

- Enable OpenAI connections in AI Hub.
- Add managed identity-based access control (RBAC).
- Expand to multi-region support.
- Add private endpoint integrations for high security environments.
