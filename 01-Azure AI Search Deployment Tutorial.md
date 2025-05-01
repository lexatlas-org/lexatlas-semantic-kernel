# Azure AI Search Deployment (CLI Tutorial)

This tutorial provides a step-by-step guide to deploying a complete Azure AI Search solution using Azure CLI. It covers provisioning the necessary resources, uploading content to blob storage, and configuring a full indexing pipeline with AI enrichment and OpenAI integration.

## Prerequisites

- An active [Azure subscription](https://portal.azure.com/)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- Git and a Bash-compatible environment
- Access to Azure OpenAI (required for GPT model deployment)
- GitHub CLI (optional, for uploading secrets)

## Quickstart

### 1. Clone the Repository

```bash
git clone git@github.com:lexatlas-org/lexatlas-semantic-kernel.git
cd lexatlas-semantic-kernel/infra/az_ai_search
```

### 2. Configure Environment Variables

Copy the example environment file:

```bash
cp .env_example .env
```

Update `.env` with the appropriate values for your Azure subscription and desired resource names. You can retrieve your subscription ID with:

```bash
az account show
```

## Step-by-Step Deployment

### 1. Create Azure Storage Resources

Run the following script to create the resource group, storage account, and blob container:

```bash
bash 10-create_storage.sh
```

### 2. Deploy Azure Cognitive Services

Provision Azure AI Services, which are required for skillsets in the indexing pipeline:

```bash
bash 11-create-ai-service.sh
```

### 3. Create Azure Cognitive Search Service

This script provisions the Azure AI Search resource:

```bash
bash 12-create_search.sh
```

### 4. Deploy Azure OpenAI

This script creates an Azure OpenAI resource and deploys a model such as GPT-4o:

```bash
bash 13-create_openai.sh
```

You must have access to Azure OpenAI to complete this step.

### 5. Upload Files to Azure Storage

Use this script to upload documents (e.g., PDFs) from a local folder to the blob container:

```bash
bash 20-upload_to_storage.sh
```

### 6. Configure and Deploy the Indexing Pipeline

This script creates the data source, skillset, index, and indexer:

```bash
bash 22-create-index.sh
```

Make sure the files in the `schema/` directory are properly configured (`skillset.json`, `index.json`, and `indexer.json`).

## Additional Tools

### View Resource Keys and Endpoints

To list and export the keys and endpoints for Azure services in `.env` format:

```bash
bash 100-show-azure-keys.sh
```

### Push Secrets to GitHub (Optional)

This script can be used to upload secrets to a GitHub repository for CI/CD integration:

```bash
bash 101-gh-secrets.sh
```

## Expected Output

After completing all steps, your environment will include:

- A provisioned Azure Cognitive Search instance
- A storage account with uploaded documents
- A configured indexing pipeline with optional AI enrichment
- Integration with Azure OpenAI for semantic applications

## References

- [Azure Cognitive Search Documentation](https://learn.microsoft.com/en-us/azure/search/)
- [Azure OpenAI Documentation](https://learn.microsoft.com/en-us/azure/cognitive-services/openai/)
- [Azure CLI Documentation](https://learn.microsoft.com/en-us/cli/azure/)

