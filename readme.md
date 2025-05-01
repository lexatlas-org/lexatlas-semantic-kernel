Here is the updated `README.md` for **LexAtlas Frontend**, with a reference to completing the `01-Azure AI Search Deployment Tutorial.md` first, and maintaining a clean, professional tone:

---

# LexAtlas Frontend

This project is built using **Chainlit**, a framework for prototyping, debugging, and sharing applications built on top of large language models (LLMs). It integrates a **PostgreSQL** database as the data layer and uses **Prisma** as the ORM for managing database migrations.

> **Note:** Before running this frontend application, make sure you have completed the setup described in the following tutorials:
>
> - `readme-01-Azure AI Search Deployment Tutorial.md` – for deploying Cognitive Search, Storage, and OpenAI using CLI scripts.
> - `readme-02-AI Foundary Deployment Tutorial.md` – for deploying the full Azure AI infrastructure stack using Bicep templates.
> - `readme-03-Agent Setup and Automation Tutorial.md` – for automatically creating and configuring AI agents with specific models and instructions for evaluation.

---

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

### 2. PostgreSQL

PostgreSQL is the primary relational database used to persist application data.

### 3. Prisma

Prisma is used as the ORM to manage database access and migrations, offering:

- Type-safe queries
- Schema modeling
- Migration tools

---

## Setup Instructions

### 1. Install Dependencies

Make sure you have:

- Python 3.10 or higher
- Node.js and npm
- PostgreSQL installed and running

Install Python dependencies:

```bash
pip install -r requirements.txt
```

Install Prisma CLI globally:

```bash
npm install -g prisma
```

---

### 2. Configure Environment Variables

Create a `.env` file in the `init/` directory based on `.env_example`:

```env
DATABASE_URL="postgresql://user:password@localhost:5432/database_name"
```

---

### 3. Set Up PostgreSQL

Install and configure PostgreSQL:

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib
```

Then, inside a PostgreSQL prompt:

```sql
CREATE USER demo_user WITH PASSWORD '12345';
CREATE DATABASE demo_db OWNER demo_user;
GRANT ALL PRIVILEGES ON DATABASE demo_db TO demo_user;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
```

---

### 4. Apply Prisma Migrations

To initialize the database:

```bash
npx prisma migrate reset
```

To create a new migration:

```bash
npx prisma migrate dev --name init
```

To deploy to production:

```bash
npx prisma migrate deploy
```

---

## Project Structure

```
.
├── app.py                # Main application file
├── kernel.py             # Semantic Kernel setup
├── infra/                # Infrastructure files
├── init/                 # Prisma schema and migrations
│   ├── schema.prisma     
│   ├── migrations/       
│   └── .env_example      
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

2. Modify the database schema in `schema.prisma`.

3. Generate a new migration:

   ```bash
   npx prisma migrate dev --name migration_name
   ```

4. Use the Chainlit interface to interact with the application and test updates.

---

## Useful Links

- [Chainlit Documentation](https://docs.chainlit.io)
- [Prisma Documentation](https://www.prisma.io/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

## Notes

- Ensure the `pgcrypto` extension is enabled for UUIDs.
- Always use `npx prisma migrate deploy` in production environments.
- Chainlit supports custom authentication via the `auth_callback` function in `app.py`.

Let me know if you'd like this saved as a file or directly integrated into your repo.