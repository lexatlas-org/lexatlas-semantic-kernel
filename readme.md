# LexAtlas Frontend

This project is built using **Chainlit**, a framework for prototyping, debugging, and sharing applications built on top of LLMs. It integrates a **PostgreSQL** database as the data layer and uses **Prisma** as the ORM for managing database migrations.

---

##  Quick Start

To run the application, use the following command:

```bash
chainlit run app.py
```

---

##  Overview

### 1. **Chainlit**
Chainlit is a framework designed to simplify the development of applications that interact with large language models (LLMs). It provides features like:
- **Prototyping**: Quickly build and test LLM-based applications.
- **Debugging**: Inspect and debug interactions with LLMs.
- **Sharing**: Share your application with others easily.

In this project, Chainlit is used to manage user sessions, handle chat interactions, and integrate with the Semantic Kernel for AI services.

### 2. **PostgreSQL**
PostgreSQL is used as the primary database for storing application data. It is a powerful, open-source relational database system that supports advanced features like JSONB, indexing, and extensions like `pgcrypto`.

### 3. **Prisma**
Prisma is an ORM (Object-Relational Mapping) tool that simplifies database access and migrations. It provides:
- **Type-safe database queries**.
- **Schema management**.
- **Migration tools** for evolving the database schema.

---

##  Setup Instructions

### 1. Install Dependencies
Ensure you have the following installed:
- Python (3.10 or higher)
- Node.js (for Prisma CLI)
- PostgreSQL

Install Python dependencies:
```bash
pip install -r requirements.txt
```

Install Prisma CLI:
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
1. Install PostgreSQL:
   ```bash
   sudo apt update
   sudo apt install postgresql postgresql-contrib
   ```
2. Create a user and database:
   ```sql
   CREATE USER demo_user WITH PASSWORD '12345';
   CREATE DATABASE demo_db OWNER demo_user;
   GRANT ALL PRIVILEGES ON DATABASE demo_db TO demo_user;
   ```

3. Enable the `pgcrypto` extension (required for UUID generation):
   ```sql
   CREATE EXTENSION IF NOT EXISTS pgcrypto;
   ```

---

### 4. Apply Prisma Migrations
Prisma is used to manage the database schema. Run the following commands to apply migrations:

1. Reset the database and apply all migrations:
   ```bash
   npx prisma migrate reset
   ```

2. Create a new migration (if needed):
   ```bash
   npx prisma migrate dev --name init
   ```

3. Deploy migrations to production:
   ```bash
   npx prisma migrate deploy
   ```

---

##  Project Structure

```
.
├── app.py                # Main application file
├── kernel.py             # Semantic Kernel setup
├── infra/                # Infrastructure files (ARM templates, Bicep, etc.)
├── init/                 # Prisma schema and migrations
│   ├── schema.prisma     # Prisma schema definition
│   ├── migrations/       # Database migrations
│   └── .env_example      # Example environment variables
├── docs/                 # Documentation
├── .chainlit/            # Chainlit configuration and translations
└── readme.md             # Project documentation
```

---

##  Development Workflow

1. **Start the Chainlit Application**:
   ```bash
   chainlit run app.py
   ```

2. **Modify the Prisma Schema**:
   Update the `schema.prisma` file in the `init/` directory to reflect changes in the database schema.

3. **Generate a New Migration**:
   ```bash
   npx prisma migrate dev --name migration_name
   ```

4. **Test the Application**:
   Use the Chainlit interface to interact with the application and verify changes.

---

##  Useful Links

- [Chainlit Documentation](https://docs.chainlit.io)
- [Prisma Documentation](https://www.prisma.io/docs)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

##  Notes

- Always ensure the `pgcrypto` extension is enabled in PostgreSQL for UUID generation.
- Use `npx prisma migrate deploy` for production environments to apply migrations safely.
- Chainlit provides a built-in authentication mechanism. Update the `auth_callback` function in `app.py` to customize authentication.

Happy coding! 🚀