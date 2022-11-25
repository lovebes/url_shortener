#!/bin/sh

# entrypoint.sh
# Docker entrypoint script.

# Wait until Postgres is ready
# while ! pg_isready -q -h $PGHOST -p $PGPORT -U $PGUSER
# do
#   echo "$(date) - waiting for database to start"
#   sleep 2
# done

# Create, migrate, and seed database if it doesn't exist.
mix ecto.reset

exec mix phx.server

