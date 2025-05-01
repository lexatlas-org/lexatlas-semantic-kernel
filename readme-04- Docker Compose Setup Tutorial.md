# 04 - Docker Compose Setup Tutorial

This guide explains how to run the initial version of the **LexAtlas** application stack using Docker Compose. It sets up a development-ready environment for working with the frontend, AI agents, and PostgreSQL database.

---

## Prerequisites

Make sure the following tools are installed on your machine:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## 1. Required Environment Variables

Before running the stack, create a `.env` file in your project root directory and define the following variables:

### Basic Configuration

```env
OPENAI_API_KEY=your-openai-api-key
CHAINLIT_AUTH_SECRET=your-chainlit-auth-secret
```

### Azure AI Agent Integration

```env
AZURE_AI_AGENT_PROJECT_CONNECTION_STRING="<region>.api.azureml.ms;<workspace-id>;<resource-group-name>;<project-name>"
AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME="gpt-4o-mini"
PROJECT_CONNECTION_STRING="<region>.api.azureml.ms;<workspace-id>;<resource-group-name>;<project-name>"
```

### Optional: Azure Cognitive Search

```env
AZURE_SEARCH_ENDPOINT=https://<your-search-service>.search.windows.net/
AZURE_SEARCH_API_KEY=your-search-api-key
AZURE_SEARCH_INDEX_NAME=your-index-name
```

> **Note:** Never commit your `.env` file to version control. Add it to `.gitignore` to keep your secrets secure.

---

## 2. Set Up Your Environment

You can define environment variables using either method below:

### Option 1: `.env` File (Recommended)

Create a `.env` file at the root of your project with all variables listed above.

### Option 2: Export in Terminal (Temporary)

```bash
export OPENAI_API_KEY=your-api-key
export CHAINLIT_AUTH_SECRET=your-auth-secret
```

These will persist only during your terminal session.

---

## 3. Run the Stack

Use Docker Compose to build and launch all services:

```bash
docker-compose up --build
```

This will:

- Build the Chainlit-based frontend application
- Start a PostgreSQL database container
- Inject environment variables from the `.env` file or shell

---

## 4. Access the Application

Once the stack is running, open your browser to:

```
http://localhost:4000
```

You’ll be prompted to authenticate via Chainlit using the token set in `CHAINLIT_AUTH_SECRET`.

---

## 5. Stop the Stack

To gracefully stop all containers:

```bash
docker-compose down
```

This will shut down all services but preserve your database volume unless manually removed.

---

## 6. Data Persistence and Analysis

All conversation history and AI agent outputs are saved to the PostgreSQL database. This includes:

- User–agent interactions
- Task results (classification, retrieval, compliance checks, and reports)
- User metadata and session logs

This data can be used for:

- Post-run analysis and auditing
- Debugging and performance evaluation
- Visualization using BI tools or Jupyter notebooks

> The PostgreSQL container uses persistent volume storage defined in `docker-compose.yml`. You can connect to it using standard PostgreSQL clients.

---

## Notes

- This is the initial version of the LexAtlas development stack
- Additional services and orchestration layers may be added in future iterations
- For production, consider using secret managers such as Azure Key Vault or Docker Secrets

