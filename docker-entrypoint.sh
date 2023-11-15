#!/bin/bash
cp /etc/postgresql/postgresql.conf /var/lib/postgresql/data/postgresql.conf
chown postgres:postgres /var/lib/postgresql/data/postgresql.conf
chmod 0644 /var/lib/postgresql/data/postgresql.conf

# Call the original PG entrypoint script
exec docker-entrypoint.sh "$@"