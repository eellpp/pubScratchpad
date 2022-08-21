https://aws.amazon.com/blogs/database/managing-postgresql-users-and-roles/  

To summarize the concepts, I have provided the following reference SQL statements for implementing the users and roles using an example scenario:

- A PostgreSQL database has been created with primary database named mydatabase.
- A new schema has been created named myschema with multiple tables.
- Two reporting users must be created with the permissions to read all tables in the schema myschema.
- Two app users must be created with permissions to read and write to all tables in the schema myschema and also to create new tables.
- The users should automatically get permissions on any new tables that are added in the future.  

```bash
-- Revoke privileges from 'public' role
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON DATABASE mydatabase FROM PUBLIC;

-- Read-only role
CREATE ROLE readonly;
GRANT CONNECT ON DATABASE mydatabase TO readonly;
GRANT USAGE ON SCHEMA myschema TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA myschema TO readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA myschema GRANT SELECT ON TABLES TO readonly;

-- Read/write role
CREATE ROLE readwrite;
GRANT CONNECT ON DATABASE mydatabase TO readwrite;
GRANT USAGE, CREATE ON SCHEMA myschema TO readwrite;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA myschema TO readwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA myschema GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO readwrite;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA myschema TO readwrite;
ALTER DEFAULT PRIVILEGES IN SCHEMA myschema GRANT USAGE ON SEQUENCES TO readwrite;

-- Users creation
CREATE USER reporting_user1 WITH PASSWORD 'some_secret_passwd';
CREATE USER reporting_user2 WITH PASSWORD 'some_secret_passwd';
CREATE USER app_user1 WITH PASSWORD 'some_secret_passwd';
CREATE USER app_user2 WITH PASSWORD 'some_secret_passwd';

-- Grant privileges to users
GRANT readonly TO reporting_user1;
GRANT readonly TO reporting_user2;
GRANT readwrite TO app_user1;
GRANT readwrite TO app_user2;
```

