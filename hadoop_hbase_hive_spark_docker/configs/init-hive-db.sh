#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE USER hive WITH PASSWORD 'hive';
  ALTER USER hive WITH SUPERUSER;
  CREATE DATABASE metastore;
  GRANT ALL PRIVILEGES ON DATABASE metastore TO hive;
  \c metastore
  \i /hive/hive-schema-2.3.0.postgres.sql
  \i /hive/hive-txn-schema-2.3.0.postgres.sql
  \pset tuples_only
  \o /tmp/grant-privs
SELECT 'GRANT SELECT,INSERT,UPDATE,DELETE ON "' || schemaname || '"."' || tablename || '" TO hive ;'
FROM pg_tables
WHERE tableowner = CURRENT_USER and schemaname = 'public';
  \o
  \i /tmp/grant-privs  
  CREATE USER hue WITH PASSWORD 'hue';
  ALTER USER hue WITH SUPERUSER;
  CREATE DATABASE hue;
  GRANT ALL PRIVILEGES ON DATABASE hue TO hue;
  \c hue
  \o /tmp/grant-privs
SELECT 'GRANT SELECT,INSERT,UPDATE,DELETE ON "' || schemaname || '"."' || tablename || '" TO hue ;'
FROM pg_tables
WHERE tableowner = CURRENT_USER and schemaname = 'public';
  \o
  \i /tmp/grant-privs  
EOSQL
