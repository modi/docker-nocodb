#!/usr/bin/env bash

set -eux

root_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

export $(cat $root_dir/.env | xargs)

sql_file="$(basename "$1")"

docker compose cp $1 "db:/tmp/$sql_file"

docker compose --project-directory=$root_dir \
    exec db \
    psql -U $X_POSTGRES_USER -f "/tmp/$sql_file"

docker compose exec db rm "/tmp/$sql_file"
