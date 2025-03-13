#!/usr/bin/env bash

set -eux

root_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

export $(cat $root_dir/.env | xargs)

backup_name=$(date +"%Y%m%d%H%M%S")

docker compose --project-directory=$root_dir \
    exec -T db \
    pg_dumpall -U $X_POSTGRES_USER > "$root_dir/backups/$backup_name.sql"
