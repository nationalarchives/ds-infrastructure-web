# Search Database Migration

## Overview

This document outlines the migration process for the Sitemap Search database.

## Migration Steps

### Get the Database Dump

- Obtain the .sql dump file of the search database from the developers on Platform.sh.

- Ensure the file is saved locally, e.g., sitemap_urls.sql.

### Upload to S3 bucket

- Upload the dump file to the S3 bucket.

### Download the database dump from S3 to the local /tmp/ directory:

- Connect to the postgres-main-prime instance and download the dump

```bash
sudo aws s3 cp s3://<path>/<filename>(sitemap_urls.sql) /tmp/
```

- Verify whether the dump file is downlaoded

```bash
ls -lh /tmp/
```

### Log in to PostgreSQL as the postgres user:

```bash
sudo -u postgres psql
```

- Enter the root password when prompted.

### Create the database:

```bash
CREATE DATABASE search;
```

### Create the application user:

```bash
CREATE USER search_app_user WITH PASSWORD 'password';
```

### Import the .sql file into the newly created search database:

```bash
sudo -u postgres psql -d search -f /tmp/sitemap_urls.sql
```

- Enter the PostgreSQL password for the postgres user when prompted.

- This command executes all the SQL statements in sitemap_urls.sql and populates the search database with the required tables and data.

### Assign ownership of the database to the user:

```bash
ALTER DATABASE search OWNER TO search_app_user;
```

### Change ownership of all tables and sequences to the application user (search_app_user) and grant privileges:

```bash
sudo -u postgres psql -d search -c "
DO \$\$ DECLARE r RECORD;
BEGIN
  FOR r IN SELECT tablename FROM pg_tables WHERE schemaname='public' LOOP
    EXECUTE 'ALTER TABLE public.' || quote_ident(r.tablename) || ' OWNER TO search_app_user;';
  END LOOP;

  FOR r IN SELECT sequencename FROM pg_sequences WHERE schemaname='public' LOOP
    EXECUTE 'ALTER SEQUENCE public.' || quote_ident(r.sequencename) || ' OWNER TO search_app_user;';
  END LOOP;
END;
\$\$;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO search_app_user;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO search_app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO search_app_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO search_app_user;
"
```

- Enter the PostgreSQL password for postgres when prompted.

- Output should confirm:

```DO
GRANT
GRANT
ALTER DEFAULT PRIVILEGES
ALTER DEFAULT PRIVILEGES
```

- This ensures that search_app_user owns all tables and sequences and has full privileges, including any future tables or sequences created in the public schema.

### Connect to the database as the application user:

```bash
psql -h localhost -U search_app_user -d search -W
```

- Enter `search_app_user` password when prompted.

### Change ownership of all views in the public schema to search_app_user:

```bash
DO $$
DECLARE r RECORD;
BEGIN
  FOR r IN SELECT table_name FROM information_schema.views WHERE table_schema='public' LOOP
    EXECUTE 'ALTER VIEW public.' || quote_ident(r.table_name) || ' OWNER TO search_app_user;';
  END LOOP;
END;
$$;
```

### Grant privileges on all tables and views:

```bash
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO search_app_user;

-- For views, usually SELECT is enough
GRANT SELECT ON ALL TABLES IN SCHEMA public TO search_app_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO search_app_user;
```

### Verify ownership and access:

- List tables:

```bash
\dt+
```

- List sequences:

```bash
\ds+
```

- List views:

```bash
\dv+
```

- This confirms that all tables, sequences, and views are owned by search_app_user and the privileges are correctly set.
