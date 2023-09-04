#!/usr/bin/env bash

set -eux

root_dir="$(dirname "$(dirname "$(readlink -f "$0")")")"

export $(cat $root_dir/.env | xargs)

# 不备份系统表
db_names=$(docker compose --project-directory=$root_dir exec -T -u $(id -u):$(id -g) db mysql --user=root --password=$X_MYSQL_ROOT_PASSWORD \
    --skip-column-names --silent \
    --execute="select group_concat(SCHEMA_NAME separator ' ') \
    from information_schema.SCHEMATA \
    where SCHEMA_NAME not in ('information_schema','mysql','performance_schema','sys')")

backup_output_dir="dbdumps/$(date +"%Y/%m")"
mkdir -p $backup_output_dir

backup_name=$(date +"%Y%m%d%H%M%S")
docker compose exec -T db mysqldump --user=root --password=root --databases $db_names > "$backup_output_dir/$backup_name.sql"
