#!/usr/bin/env bash

set -eux

root_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

export $(cat $root_dir/.env | xargs)

docker compose exec -T db mysql --user=root --password=$X_MYSQL_ROOT_PASSWORD < "$1"
