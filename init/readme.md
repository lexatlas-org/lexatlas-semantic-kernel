# Apply Prisma Migrations

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