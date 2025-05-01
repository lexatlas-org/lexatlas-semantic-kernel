# LexAtlas Frontend

This project is built using **Chainlit**, a framework for prototyping, debugging, and sharing applications built on top of large language models (LLMs). It integrates with **Azure AI Services** and Semantic Kernel to manage conversational AI agents in legal and regulatory scenarios.

> **Note:** Before running this frontend application, make sure you have completed the setup described in the following tutorials:
>
> - `readme-01-Azure AI Search Deployment Tutorial.md` – for deploying Cognitive Search, Storage, and OpenAI using CLI scripts.
> - `readme-02-AI Foundary Deployment Tutorial.md` – for deploying the full Azure AI infrastructure stack using Bicep templates.
> - `readme-03-Agent Setup and Automation Tutorial.md` – for automatically creating and configuring AI agents with specific models and instructions for evaluation.
> - `readme-04-Docker Compose Setup Tutorial.md` – for running the initial version of the application stack using Docker Compose with environment variables configured for local development.

---

## Reference

For an overview of the project's vision and context, see the accompanying document:

[LexAtlas — Legal Intelligence for Real-World Impact (PDF)](docs/LexAtlas_ Legal Intelligence for Real-World Impact.pdf)

## Quick Start

To run the application, use the following command:

```bash
chainlit run app.py
```

---

## Overview

### 1. Chainlit

Chainlit is a framework designed to simplify the development of applications that interact with large language models. It provides:

- Prototyping features
- Debugging tools
- Sharing mechanisms for LLM-based apps

In this project, Chainlit manages user sessions, chat interactions, and integrates with Azure AI services.

### 2. Semantic Kernel Integration

This frontend communicates with AI agents hosted in Azure through Semantic Kernel, enabling:

- Multi-agent orchestration
- Tool and plugin integration
- Evaluation pipelines for legal tasks

---

## Setup Instructions

### 1. Install Dependencies

Make sure you have:

- Python 3.10 or higher
- Node.js and npm

Install Python dependencies:

```bash
pip install -r requirements.txt
```

Install Chainlit globally (if not already):

```bash
pip install chainlit
```

---

### 2. Configure Environment Variables

Create a `.env` file in the root of your project based on the provided `.env_example` and define required keys:

```env
OPENAI_API_KEY=your-openai-api-key
CHAINLIT_AUTH_SECRET=your-auth-secret
AZURE_AI_AGENT_PROJECT_CONNECTION_STRING=...
AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME=gpt-4o-mini
```

---

## Project Structure

```
.
├── app.py                # Main application file
├── kernel.py             # Semantic Kernel setup
├── infra/                # Infrastructure files
├── prompts/              # Prompt templates for AI agents
├── docs/                 # Documentation
├── .chainlit/            # Chainlit configuration
└── readme.md             # Project documentation
```

---

## Development Workflow

1. Start the Chainlit application:

   ```bash
   chainlit run app.py
   ```

2. Update prompt instructions or semantic kernel settings as needed.

3. Use the Chainlit interface to interact with the application and validate AI behavior.

---

## Useful Links

- [Chainlit Documentation](https://docs.chainlit.io)
- [Semantic Kernel](https://aka.ms/semantic-kernel)
- [OpenAI Documentation](https://platform.openai.com/docs)

---

## Notes

- Make sure your environment variables point to valid Azure services and deployments.
- Agent orchestration is handled via Semantic Kernel logic inside `kernel.py`.
- You can switch between `app.py` and `app_chat.py` by changing the `CHAINLIT_APP` environment variable.

