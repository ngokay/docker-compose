#!/bin/bash
set -e

echo "Running post_init script..."

psql -d postgres -U postgres -h localhost -p 5432 <<'EOSQL'
DO $$
BEGIN
   IF NOT EXISTS (
      SELECT FROM pg_catalog.pg_roles WHERE rolname = 'replicator'
   ) THEN
      CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'replicate';
   END IF;
END
$$;
EOSQL
