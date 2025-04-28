import psycopg2
import os

# Load database URL from environment variable or use default
DATABASE_URL = os.getenv('DATABASE_URL', 'postgresql://postgres:postgres@localhost:5432/postgres')

try:
    # Connect to your postgres DB
    conn = psycopg2.connect(DATABASE_URL)

    # Open a cursor to perform database operations
    cur = conn.cursor()

    # Execute a simple query
    cur.execute('SELECT version();')

    # Fetch and print the result
    db_version = cur.fetchone()
    print(f"Connected successfully! PostgreSQL version: {db_version[0]}")

    # Clean up
    cur.close()
    conn.close()

except Exception as e:
    print(f"Failed to connect to the database: {e}")
