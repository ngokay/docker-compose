#!/bin/bash
set -e

echo "Configuring Primary for replication..."

# Tạo role replication
psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<-EOSQL
  DO \$\$
  BEGIN
    IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'replicator') THEN
      CREATE ROLE replicator WITH REPLICATION LOGIN PASSWORD 'Ngotheanh93@';
    END IF;
  END
  \$\$;
EOSQL

# Cấu hình replication trong postgresql.conf
echo "wal_level = replica" >> "$PGDATA/postgresql.conf"
echo "max_wal_senders = 10" >> "$PGDATA/postgresql.conf"
echo "wal_keep_size = 64" >> "$PGDATA/postgresql.conf"
echo "listen_addresses = '*'" >> "$PGDATA/postgresql.conf"

# Cho phép replica kết nối
echo "host replication replicator 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"

echo "Primary configured."
