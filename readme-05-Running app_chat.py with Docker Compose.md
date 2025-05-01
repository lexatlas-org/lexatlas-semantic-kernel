## ⚠️ Note on Container Permissions

We are currently working on resolving permission issues related to running the application within the Docker container. In the meantime, we recommend running `app_chat.py` directly from your local environment using a virtual environment (`venv`). Below is a quick guide to do so:

### ✅ Quick Guide: Run `app_chat.py` Locally with venv

1. **Create the virtual environment** (if you haven’t already):

```bash
python -m venv venv
```

2. **Activate the virtual environment**:

- On Linux/macOS:

```bash
source venv/bin/activate
```

- On Windows:

```bash
venv\Scripts\activate
```

3. **Install dependencies**:

```bash
pip install -r requirements.txt
```

4. **Configure your environment variables** in a `.env` file (in the project root). Make sure to include the following:

#### 🔗 `DATABASE_URL`

Chainlit requires a PostgreSQL connection. If you're working locally:

- Install PostgreSQL on your machine.
  - **macOS:** `brew install postgresql`
  - **Ubuntu:** `sudo apt install postgresql`
  - **Windows:** Download from [https://www.postgresql.org/download/](https://www.postgresql.org/download/)

- Create a local database and use a connection string like:

```env
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/lexatlas
```

Ensure the database exists and is accessible with the provided credentials.

#### 🔐 `LITERAL_API_KEY`

Chainlit uses this for its internal features and telemetry. You can obtain it by creating a free account at [https://app.chainlit.io](https://app.chainlit.io), then go to your account settings to get the key.

```env
LITERAL_API_KEY=your_chainlit_api_key
```

> Your `.env` file should also include other required keys (e.g., OpenAI, Azure) used throughout the app.

5. **Run the application**:

```bash
chainlit run app_chat.py --host 0.0.0.0 --port 8000
```

> This will launch the app locally at [http://localhost:8000](http://localhost:8000)
 
 
# 05 - Running app_chat.py with Docker Compose

This guide explains how to run the `app_chat.py` variant of the LexAtlas frontend using Docker Compose. This version of the application is intended for conversational testing with AI agents using Chainlit, integrated with Semantic Kernel and Azure AI infrastructure.

---

## 1. Purpose

The `app_chat.py` script provides an alternative entry point to the LexAtlas frontend, allowing for streamlined, chat-focused interactions with AI agents. It uses the same infrastructure and environment configuration as the standard `app.py`, but is optimized for testing agent orchestration, plugins, and tool execution.

---

## 2. Prerequisites

Before running `app_chat.py`, ensure that:

- You’ve completed the setup described in `04 - Docker Compose Setup Tutorial`
- Your `.env` file includes all required variables for OpenAI and Azure AI integration
- Your Docker image includes both `app.py` and `app_chat.py`

---

## 3. Update Dockerfile

Make sure your Dockerfile includes both application files:

```dockerfile
COPY app.py app_chat.py kernel.py .env /app/
```

Then modify the command to accept a configurable entry point via an environment variable:

```dockerfile
ENV CHAINLIT_APP=app_chat.py
CMD ["chainlit", "run", "app.py", "--host", "0.0.0.0", "--port", "8000"]
```
 
---

## 4. Configure Docker Compose

In your `docker-compose.yml`, set the application entry point for this variant:

```yaml
services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - CHAINLIT_APP=app_chat.py
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - CHAINLIT_AUTH_SECRET=${CHAINLIT_AUTH_SECRET}
      - AZURE_AI_AGENT_PROJECT_CONNECTION_STRING=${AZURE_AI_AGENT_PROJECT_CONNECTION_STRING}
      - AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME=${AZURE_AI_AGENT_MODEL_DEPLOYMENT_NAME}
      - PROJECT_CONNECTION_STRING=${PROJECT_CONNECTION_STRING}
    depends_on:
      - db
```

> Ensure all referenced environment variables are defined in your `.env` file.

---

## 5. Run the Stack with app_chat.py

From your project root, run:

```bash
docker-compose up --build
```

This will launch the `app_chat.py` Chainlit application on [http://localhost:4000](http://localhost:4000).

---

## 6. Use Case

This mode is ideal for:

- Testing conversational flows between multiple AI agents
- Exploring plugin/tool integration before deploying a frontend
- Running functional evaluations using real prompts and simulated user input

 