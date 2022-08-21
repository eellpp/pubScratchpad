Users, groups, and roles are the same thing in PostgreSQL, with the only difference being that users have permission to log in by default.   
Everythin internally is a role  


In PostgreSQL, schema is a named collection of tables, views, functions, constraints, indexes, sequences etc.   
- PostgreSQL can have multiple databases in each instance.
- Each database can have multiple schemas.
- Each schema can have multiple tables.

You can have a database named postgres and have multiple schemas based on your application like ecommerce, auth etc.

By default, the public schema is used in PostgreSQL. Any SQL queries executed will run against the public schema by default unless explicitly mentioned  

Roles can become member of other rols and inherit their previledges.  

### postgres does not have user as in other db. But has user role
PostgreSQL uses roles to represent user accounts. It doesn’t use the user concept like other database systems.  
Typically, roles can log in are called login roles. They are equivalent to users in other database systems.  

### Role Attributes
Role attributes are flags on the role itself that determine some of the core privileges it has on the database  
`LOGIN`: Allows users to initially connect to the database cluster using this role. The CREATE USER command automatically adds this attribute, while CREATE ROLE command does not.  
`SUPERUSER`: Allows the role to bypass all permission checks except the right to log in. Only other SUPERUSER roles can create roles with this attribute.
`CREATEDB`: Allows the role to create new databases.  
`CREATEROLE`: Allows the role to create, alter, and delete other roles. This attribute also allows the role to assign or alter role membership. An exception is that a role with the CREATEROLE attribute cannot alter SUPERUSER roles without also having the SUPERUSER attribute.``
`PASSWORD`: Assigns a password to the role that will be used with password or md5 authentication mechanisms. This attribute takes a password in quotations as an argument directly after the attribute keyword  

```bash
CREATE ROLE alice LOGIN PASSWORD 'securePass1'; #creates a role called alice that has the login privilege and an initial password:
CREATE ROLE john  SUPERUSER  LOGIN  PASSWORD 'securePass1'; #you must be a superuser in order to create another superuser role  
CREATE ROLE dev_api WITH LOGIN PASSWORD 'securePass1' VALID UNTIL '2030-01-01'; 
CREATE ROLE api LOGINPASSWORD 'securePass1' CONNECTION LIMIT 1000;
```
### psql — PostgreSQL interactive terminal

```bash
psql -d database -U  user -W
psql -h host -d database -U user -W 

\c dbname username #switch database with a new user
\l                  # list all available database 
\dt                 # list all tables in current database
\d table_name       # describe table name
\du                 # list all current users and their roles  
\s                  # comand history 
\i                  # execute commands from file 
\timing             # turn on timing for sql command 
\q                  # quit


```

https://blog.crunchydata.com/blog/five-tips-for-a-healthier-postgres-database-in-the-new-year  

1. Set a statement timeout  
2. Ensure you have query tracking  
3. Log slow running queries  
4. Improve your connection management : Use PgBouncer instead of connection pooling at ORM  
5. Find your goldilocks range for indexes:   a lot of indexes that became a tangled ball of yarn over time  
6. Weekly VACUUM ANALYZE on some of the busiest write tables  
7. running ANALYZE and having up to date table statistics


### Connections
Each new connection to Postgres is a forked process.  
A new Postgres client connection involves TCP setup, process creation and backend initialization  
This process comes with its own memory allocation of roughly 10 MB with at least some load for the query. In this sense every new connection is already consuming some of those precious resources you want processing queries. For 300 database connections this is 3 GB of memory going just to managing those connections—memory which could be better used for caching your data.  

PgBouncer is an open-source, lightweight, single-binary connection pooler for PostgreSQL. It can pool connections to one or more databases (on possibly different servers) and serve clients over TCP and Unix domain sockets.  

PgBouncer acts as a Postgres server, so simply point your client to the PgBouncer port.

Installing PgBouncer on the web server is good when short-lived connections are used. Then the connection setup latency is minimised. (TCP requires a couple of packet roundtrips before a connection is usable.) Installing PgBouncer on the database server is good when there are many different hosts (e.g., web servers) connecting to it. Then their connections can be optimised together.  

http://www.pgbouncer.org/faq.html  


