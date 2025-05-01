# Initial Version of the Stack: Running with Docker Compose

This guide explains how to run the initial version of the **LexAtlas** application stack using Docker Compose. It sets up a development-ready environment for working with the frontend, agents, and database.

---

## Prerequisites

Make sure the following tools are installed:

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

---

## 1. Required Environment Variables

Before running the stack, you need to provide two environment variables.

### `OPENAI_API_KEY`

This is your API key for accessing OpenAI services (e.g., GPT-4, GPT-4o).

To obtain it:

1. Visit [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys)
2. Log in with your OpenAI account
3. Click **"Create new secret key"**
4. Copy the key and store it securely

### `CHAINLIT_AUTH_SECRET`

This is used to secure access to the Chainlit frontend.

To generate a strong secret:

```bash
openssl rand -base64 32
```

Copy the resulting string and use it in your `.env` file or environment settings.

---

## 2. Set Up Your Environment

You can set the variables in one of two ways:

### Option 1: Using a `.env` File

Create a `.env` file in the root of your project:

```bash
touch .env
```

Then add the following:

```env
OPENAI_API_KEY=your-openai-api-key-here
CHAINLIT_AUTH_SECRET=your-random-auth-secret-here
```

> **Important:** Never commit `.env` files to version control. Add it to `.gitignore`.

---

### Option 2: Export Them in Your Shell

You can also export them temporarily in your terminal session:

```bash
export OPENAI_API_KEY=your-openai-api-key-here
export CHAINLIT_AUTH_SECRET=your-random-auth-secret-here
```

These will only persist while your shell session is active.

---

## 3. Run the Stack

Build and launch the services with:

```bash
docker-compose up --build
```

This will:

- Build Docker containers
- Inject your environment variables
- Start the app, PostgreSQL, and other services

---

## 4. Access the Application

Once the containers are up, open your browser:

```
http://localhost:4000
```

You'll be prompted to log in using Chainlit’s built-in authentication.

---

## 5. Stop the Stack

To shut everything down:

```bash
docker-compose down
```

This stops and removes all containers.

---

## 6. Data Persistence and Analysis

All user interactions, conversation history, and agent responses are **persistently stored in the local PostgreSQL database**. This includes:

- Chat history between the user and agents
- Output from classification, regulation retrieval, compliance checks, and reports
- User credentials and session metadata (if enabled)

This setup allows for:

- **Auditing and traceability** of agent decisions
- **Post-run analysis** for debugging, fine-tuning, or evaluation
- **Data extraction and visualization** using BI tools or Jupyter notebooks

> **Note:** The database runs inside a Docker container and is mounted with persistent volume storage by default. You can connect to it using any PostgreSQL client for further inspection.

---

## Notes

- This setup represents the **initial version** of the development stack.
- As the project evolves, more services and configurations will be added.
- For production environments, consider using secure secret managers like **Azure Key Vault** or **Docker Secrets**.
 