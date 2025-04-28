# Run
see https://github.com/Chainlit/chainlit-community/blob/main/packages/data_layers/sqlalchemy/README.md 

```bash
chainlit run app.py
```



#  PostgreSQL Setup and Prisma Migration Guide

This guide explains how to install PostgreSQL, set up users and databases, and apply Prisma migrations.

---

## 1. Install PostgreSQL

```bash
# Update system packages
sudo apt update
sudo apt upgrade -y

# Install PostgreSQL and additional tools
sudo apt install postgresql postgresql-contrib -y

# Verify PostgreSQL service status
sudo systemctl status postgresql

# Switch to the postgres system user
sudo -i -u postgres
psql
```

---

## 2. Create User and Database

Inside the PostgreSQL shell (`psql`):

```sql
-- Create a new user with password
CREATE USER demo_user WITH PASSWORD '12345';

-- Create a new database owned by the user
CREATE DATABASE demo_db OWNER demo_user;

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE demo_db TO demo_user;
```

Exit `psql`:

```bash
\q
exit
```

---

## 3. Connect to the Database

```bash
psql -U demo_user -d demo_db -h localhost
```

---

## 4. Fix User Privileges (if needed)

If Prisma requires the user to create databases (for shadow database during migrations):

```bash
# Switch to postgres user
sudo -i -u postgres
psql

# Grant CREATEDB privilege to the user
ALTER ROLE demo_user CREATEDB;

# Exit
\q
exit
```

---

## 5. Apply Prisma Migrations

Use the following commands depending on the stage:

```bash
# Reset the database and reapply all migrations
npx prisma migrate reset

# (Optional) Reset without confirmation prompts
npx prisma migrate reset --force

# Create and apply a new migration
npx prisma migrate dev --name init

# Deploy migrations to production
npx prisma migrate deploy
```

---

## 6. Manual Database Reset (optional)

If you prefer a manual reset:

```sql
-- Drop the public schema and everything inside
DROP SCHEMA public CASCADE;

-- Recreate the public schema
CREATE SCHEMA public;

-- Grant privileges
GRANT ALL ON SCHEMA public TO demo_user;
GRANT ALL ON SCHEMA public TO public;
```

---

#  Notes

- Use `npx prisma migrate dev` during development.
- Use `npx prisma migrate deploy` for production environments.
- Resetting the database will erase all data.
- Always double-check privileges if Prisma reports permission errors.

 